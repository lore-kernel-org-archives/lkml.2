Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab0KJUjA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 15:39:00 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:54064 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab0KJUi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 15:38:59 -0500
Message-ID: <4CDB02D1.2050400@vlnb.net>
Date: Wed, 10 Nov 2010 23:38:41 +0300
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: Joe Eykholt <jeykholt@cisco.com>
CC: Boaz Harrosh <bharrosh@panasas.com>, Greg KH <greg@kroah.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        scst-devel <scst-devel@lists.sourceforge.net>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>, Vu Pham <vuhuong@mellanox.com>,
        Bart Van Assche <bart.vanassche@gmail.com>,
        James Smart <James.Smart@Emulex.Com>, Andy Yan <ayan@marvell.com>,
        Chetan Loke <generationgnu@yahoo.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Hannes Reinecke <hare@suse.de>,
        Richard Sharpe <realrichardsharpe@gmail.com>,
        Daniel Henrique Debonzi <debonzi@linux.vnet.ibm.com>
Subject: Re: [PATCH 8/19]: SCST SYSFS interface implementation
References: <20101011213235.GA11489@kroah.com> <4CB4AEB9.30501@vlnb.net> <20101012190345.GA25737@kroah.com> <4CB75E81.7000208@vlnb.net> <20101014200413.GA30831@kroah.com> <4CC1CA4D.1090609@vlnb.net> <20101022175624.GA13640@kroah.com> <4CC1DAA2.7030602@vlnb.net> <20101022185437.GA9103@kroah.com> <4CD8566D.1020202@vlnb.net> <20101109002829.GA22633@kroah.com> <4CD9A9B8.70708@vlnb.net> <4CDA6CD4.3010308@panasas.com> <4CDAFE6E.7050200@vlnb.net> <4CDB00C2.2090200@cisco.com>
In-Reply-To: <4CDB00C2.2090200@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:qHStIY+hGe1OcvjYHI0iQfX0u8XZhzooKZfVa94ZhOG
 lIBj1X9+uirIOODhBr9PQYJaykuPiqRizwpnby4sGIO1rlBnb+
 nxLGyGrbKrxe91Xar1+jNtkEvKWSFSXZXsnwaVUyplmE1OuVhX
 HIUm/MDPBUU02u/379GW4WR7vmBlKmDlDU4+nSlIsz3R+7eqXk
 nGLc9Za1x9gbbsY5C81WA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Eykholt, on 11/10/2010 11:29 PM wrote:
>> Thanks for sharing your thoughts with us. But the question isn't about
>> if it's possible to implement what we need locklessly. The question is
>> in two approaches how to synchronously delete objects with entries on SYSFS:
>>
>> 1. struct object_x {
>> 	...
>> 	struct kobject kobj;
>> 	struct completion *release_completion;
>> };
>>
>> static void x_release(struct kobject *kobj)
>> {
>> 	struct object_x *x;
>> 	struct completion *c;
>>
>> 	x = container_of(kobj, struct object_x, kobj);
>> 	c = x->release_completion;
>> 	kfree(x);
>> 	complete_all(c);
>> }
>>
>> void del_object(struct object_x *x)
>> {
>> 	DECLARE_COMPLETION_ONSTACK(completion);
>>
>> 	...
>> 	x->release_completion = &completion;
>> 	kobject_put(&x->kobj);
>> 	wait_for_completion(&completion);
>> }
>>
>> and
>>
>> 2. struct object_x {
>> 	...
>> 	struct kobject kobj;
>> 	struct completion release_completion;
>> };
>>
>> static void x_release(struct kobject *kobj)
>> {
>> 	struct object_x *x;
>>
>> 	x = container_of(kobj, struct object_x, kobj);
>> 	complete_all(&x->release_completion);
>> }
>>
>> void del_object(struct object_x *x)
>> {
>> 	...
>> 	kobject_put(&x->kobj);
>> 	wait_for_completion(&completion);
>> 	...
>> 	kfree(x);
>> }
> 
> I'll admit I don't understand this all that well, but
> why not just have x_release() (based on (2))
> do free(x), and have del_object
> do the kobject_put(&x->kobj) as its very last thing?
> Then you don't need the completion.

We are discussing _synchronous_ delete of x, so need to wait until
x->kobj released, hence the completion is needed in both cases.

For instance, the sync delete is needed for targets to let the
corresponding target driver be safely unloaded after its target
unregistered.

Vlad
