Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161498Ab2CSPmP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 11:42:15 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:45962
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759100Ab2CSPmM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 11:42:12 -0400
X-SpamScore: -24
X-BigFish: VPS-24(zz9371I936eK179dN542M1432N98dKzz1202hzz8275bh8275dhz2dh668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M152A5-01-1VF-02
X-M-MSG: 
From: "Chen, Dennis (SRDC SW)" <Dennis1.Chen@amd.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "beattiem@uk.ibm.com" <beattiem@uk.ibm.com>,
        "holzheu@de.ibm.com" <holzheu@de.ibm.com>,
        "munzert@de.ibm.com" <munzert@de.ibm.com>,
        "linux390@de.ibm.com" <linux390@de.ibm.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>
Subject: RE: [PATCH]s390/char/vmur.c: memory leak Fix in the driver
Thread-Topic: [PATCH]s390/char/vmur.c: memory leak Fix in the driver
Thread-Index: Ac0EddW23nEJHEP4TgOzkdjHvih49AA/VbzwAAGFogAAAQ/MAAAaGOJw
Date: Mon, 19 Mar 2012 15:42:00 +0000
Message-ID: <491D6B4EAD0A714894D8AD22F4BDE0430560BF@SCYBEXDAG04.amd.com>
References: <491D6B4EAD0A714894D8AD22F4BDE0430495F2@SCYBEXDAG04.amd.com>
	<491D6B4EAD0A714894D8AD22F4BDE04304FF5A@SCYBEXDAG04.amd.com>
	<20120319113744.5992d48f@de.ibm.com> <20120319120808.7e34d652@de.ibm.com>
In-Reply-To: <20120319120808.7e34d652@de.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.74.102]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 7:08 PM, Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:
> On Mon, 19 Mar 2012 11:37:44 +0100
> Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:
>
>> On Mon, 19 Mar 2012 01:55:40 +0000
>> "Chen, Dennis (SRDC SW)" <Dennis1.Chen@amd.com> wrote:
>>
>> > CC'ing maintainer: Martin Schwidefsky &  Heiko Carstens...
>> >
>> > -----Original Message-----
>> > From: Chen, Dennis (SRDC SW)
>> > Sent: Sunday, March 18, 2012 3:41 AM
>> > To: linux-kernel@vger.kernel.org
>> > Cc: beattiem@uk.ibm.com; holzheu@de.ibm.com; munzert@de.ibm.com; linux390@de.ibm.com; linux-s390@vger.kernel.org; Chen, Dennis (SRDC SW)
>> > Subject: [PATCH]s390/char/vmur.c: memory leak Fix in the driver
>> >
>> > This patch is used to fix a memory leak issue in s390/char/vmur.c: a character device instance is
>> > allocated by cdev_alloc, the cdev_del will not free that space if cdev_init is applied before.
>> >
>> > Signed-off-by: dennis1.chen@amd.com
>> > --- a/s390/char/vmur.c  2012-03-18 02:50:47.950963949 +0800
>> > +++ b/s390/char/vmur.c  2012-03-18 03:12:04.790936740 +0800
>> > @@ -903,7 +903,7 @@ static int ur_set_online(struct ccw_devi
>> >                 goto fail_urdev_put;
>> >         }
>> >
>> > -       cdev_init(urd->char_device, &ur_fops);
>> > +       urd->char_device->ops = &ur_fops;
>> >         urd->char_device->dev = MKDEV(major, minor);
>> >         urd->char_device->owner = ur_fops.owner;
>> >
>>
>> How does that fix anything? My copy of cdev_init looks like this:
>>
>> void cdev_init(struct cdev *cdev, const struct file_operations *fops)
>> {
>>         memset(cdev, 0, sizeof *cdev);
>>         INIT_LIST_HEAD(&cdev->list);
>>         kobject_init(&cdev->kobj, &ktype_cdev_default);
>>         cdev->ops = fops;
>> }
>>
>> It does not allocate anything but it initializes some more fields.
>> The new code would only initialize the ops field. In addition
>> cdev_del does a kobject_put and the release function of the object
>> will call cdev_dynamic_release as far as I can tell. That code
>> should be fine as it is.
>
> Hmm, forget that. cdev_init has a second kobject_init that replaces
> ktype_cdev_dynamic with ktype_cdev_default. cdev_alloc already does
> the initialization and your fix is just fine.
> Seems like cdev_init is only there for static cdev structures.
>
> --

Yes, you're right. So if we don't have this patch, all the cdev instance allocated by cdev_alloc() will not freed by cdev_del as expected,
if the system running with long enough time, memory will exhaust, especially for a server platform...



