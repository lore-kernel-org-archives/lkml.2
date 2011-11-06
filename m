Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751509Ab1KFKJh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 05:09:37 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:53423 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab1KFKJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 05:09:34 -0500
Subject: Re: [GIT PULL] ib_srpt: Initial SRP Target merge for v3.2-rc1
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        target-devel <target-devel@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Roland Dreier <roland@purestorage.com>, Christoph Hellwig <hch@lst.de>
In-Reply-To: <CAO+b5-rjKdZtBjZ=qyRnavDubtHWSGihROHEUok6o+bCNc3TpA@mail.gmail.com>
References: <1320437452.5859.96.camel@haakon2.linux-iscsi.org>
	 <CAO+b5-pOi_+Y+jcExxEzParHOdU6YB4WaB-onH_PLXugzLKjzg@mail.gmail.com>
	 <1320516243.5859.184.camel@haakon2.linux-iscsi.org>
	 <CAO+b5-rjKdZtBjZ=qyRnavDubtHWSGihROHEUok6o+bCNc3TpA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 06 Nov 2011 02:09:30 -0800
Message-ID: <1320574170.5859.370.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-11-06 at 08:34 +0100, Bart Van Assche wrote:
> On Sat, Nov 5, 2011 at 7:04 PM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> > On Sat, 2011-11-05 at 08:37 +0100, Bart Van Assche wrote:
> >> On Fri, Nov 4, 2011 at 9:10 PM, Nicholas A. Bellinger
> >> <nab@linux-iscsi.org> wrote:
> >> > This is the PULL request for an initial merge of the ib_srpt driver
> >> > using mainline target infrastructure into v3.2-rc1.
> >>
> >> In case anyone is interested, the most important unaddressed comments
> >> for this version of ib_srpt are:
> >> - There are still too many module parameters. This makes ib_srpt
> >> harder to use than necessary because several of these parameters can
> >> only be set at module load time.
> >
> > Can you be more specific here..?  I went through the module parameters
> > and made the ones that where used in a per-port specific context into
> > configfs attributes as Roland recommended, but it seems like you are
> > saying that more should be made into attributes.  Which ones..?
> 
> Several read-only kernel module parameters remain. That's fine in
> out-of-tree code since it will be compiled as a kernel module only.
> But anyone who tries to build with CONFIG_INFINIBAND_SRPT=y will
> notice that it's impossible to change the value of these read-only
> kernel module parameters.
> 

So after the cleanups, srp_max_req_size, srpt_srq_size and
srpt_service_guid appear as the remaining module parameters.  The first
two are required at srpt_add_one() -> srpt_device allocation time
(usually at initial load time), and should remain as global scope
parameters correct..?  To address the point with
CONFIG_INFINIBAND_SRPT=y, how about assigning these two values for each
srpt_device during srpt_add_one(), and reference them directly in
srpt_device so their respective module parameter can become S_IRUGO|
S_IWUSR...?

We have also discussed srpt_service_guid a bit before, which you
indicated needed to stay in current code as global scope, and presumably
should not change value after loading.  Looking at the actual usage, one
post merge improvement we can consider is seeing if it's possible to
move ib_cm_listen() out of srpt_add_one() and have it driven instead by
configfs context in order to optionally set srpt_service_guid on a per
target endpoint basis to get us some more flexibility. 

> >> - The last WQE event can arrive before the queue pair is reset,
> >> resulting in a hanging session and blocking future logins
> >> (http://www.mail-archive.com/linux-rdma@vger.kernel.org/msg09678.html).
> >
> > Yep, was going to get this resolved post merge along with my patch now
> > in lio-core.git to address active I/O shutdown with ib_srpt.
> 
> Your "active I/O shutdown" patch does not address the "last WQE" issue.

The current patch in lio-core allows ib_srpt to push active I/O and
perform shutdown + unload without hanging (or crashing) at this point.
Active I/O tests with physical link layer failures also seems to work,
but mixing to two together still obviously needs more testing.

For the "last WQE" you've mentioned, I'm happy to accept a patch to
address this as you know the code better than me.  Otherwise, I'll be
digging this out of your out-of-tree code as a seperate item and
figuring out how to reproduce and test this special case.

> 
> >> - The "ib_srpt: Convert srp_max_rdma_size into per port configfs
> >> attribute" contradicts the I/O controller concept. This is a bug.
> >> (http://www.mail-archive.com/linux-rdma@vger.kernel.org/msg09677.html).
> >
> > As mentioned in the thread, I deferred to Roland's input on that one.
> > So you're saying this should be made back into a module parameter now,
> > or what..?
> 
> I see two possible ways forward:
> - Convert the per-port max_rdma_size configfs variable into a
> per-module configfs variable.

We don't need to add any per-module configfs target variables, we
already have /sys/module/$NAME/parameters/ for that.  ;)

> - Remove the max_rdma_size variable from configfs entirely and compute
> the max_rdma_size from the HCA properties in struct ib_device_attr.
> 

What did you have in mind..?  This should be based on ->max_sge *
PAGE_SIZE, or something else from ib_device_attr..?  

Thanks,

--nab



