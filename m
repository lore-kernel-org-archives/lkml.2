Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751254Ab1KFHeY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 02:34:24 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55908 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab1KFHeW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 02:34:22 -0500
MIME-Version: 1.0
In-Reply-To: <1320516243.5859.184.camel@haakon2.linux-iscsi.org>
References: <1320437452.5859.96.camel@haakon2.linux-iscsi.org>
	<CAO+b5-pOi_+Y+jcExxEzParHOdU6YB4WaB-onH_PLXugzLKjzg@mail.gmail.com>
	<1320516243.5859.184.camel@haakon2.linux-iscsi.org>
Date: Sun, 6 Nov 2011 08:34:20 +0100
X-Google-Sender-Auth: k57Qq44xs1Rb_7NzB6bztSNXY3E
Message-ID: <CAO+b5-rjKdZtBjZ=qyRnavDubtHWSGihROHEUok6o+bCNc3TpA@mail.gmail.com>
Subject: Re: [GIT PULL] ib_srpt: Initial SRP Target merge for v3.2-rc1
From: Bart Van Assche <bvanassche@acm.org>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        target-devel <target-devel@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Roland Dreier <roland@purestorage.com>, Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 5, 2011 at 7:04 PM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> On Sat, 2011-11-05 at 08:37 +0100, Bart Van Assche wrote:
>> On Fri, Nov 4, 2011 at 9:10 PM, Nicholas A. Bellinger
>> <nab@linux-iscsi.org> wrote:
>> > This is the PULL request for an initial merge of the ib_srpt driver
>> > using mainline target infrastructure into v3.2-rc1.
>>
>> In case anyone is interested, the most important unaddressed comments
>> for this version of ib_srpt are:
>> - There are still too many module parameters. This makes ib_srpt
>> harder to use than necessary because several of these parameters can
>> only be set at module load time.
>
> Can you be more specific here..?  I went through the module parameters
> and made the ones that where used in a per-port specific context into
> configfs attributes as Roland recommended, but it seems like you are
> saying that more should be made into attributes.  Which ones..?

Several read-only kernel module parameters remain. That's fine in
out-of-tree code since it will be compiled as a kernel module only.
But anyone who tries to build with CONFIG_INFINIBAND_SRPT=y will
notice that it's impossible to change the value of these read-only
kernel module parameters.

>> - The last WQE event can arrive before the queue pair is reset,
>> resulting in a hanging session and blocking future logins
>> (http://www.mail-archive.com/linux-rdma@vger.kernel.org/msg09678.html).
>
> Yep, was going to get this resolved post merge along with my patch now
> in lio-core.git to address active I/O shutdown with ib_srpt.

Your "active I/O shutdown" patch does not address the "last WQE" issue.

>> - The "ib_srpt: Convert srp_max_rdma_size into per port configfs
>> attribute" contradicts the I/O controller concept. This is a bug.
>> (http://www.mail-archive.com/linux-rdma@vger.kernel.org/msg09677.html).
>
> As mentioned in the thread, I deferred to Roland's input on that one.
> So you're saying this should be made back into a module parameter now,
> or what..?

I see two possible ways forward:
- Convert the per-port max_rdma_size configfs variable into a
per-module configfs variable.
- Remove the max_rdma_size variable from configfs entirely and compute
the max_rdma_size from the HCA properties in struct ib_device_attr.

Bart.
