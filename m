Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758449Ab2ILM4s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 08:56:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9296 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758410Ab2ILM4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 08:56:44 -0400
Message-ID: <5050867B.2080605@redhat.com>
Date: Wed, 12 Sep 2012 14:56:27 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jens Axboe <axboe@kernel.dk>, Ric Wheeler <rwheeler@redhat.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 3/3] block: add back command filter modification via sysfs
References: <1347449133-26476-1-git-send-email-pbonzini@redhat.com> <1347449133-26476-4-git-send-email-pbonzini@redhat.com> <20120912134124.55d968ef@pyramind.ukuu.org.uk>
In-Reply-To: <20120912134124.55d968ef@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 12/09/2012 14:41, Alan Cox ha scritto:
>> > +	if (!q->cmd_filter) {
>> > +		q->cmd_filter = kmalloc(sizeof(struct blk_cmd_filter),
>> > +					GFP_KERNEL);
>> > +		blk_set_cmd_filter_defaults(q->cmd_filter);
>> > +	}
>> > +
> This also needs CAP_SYS_RAWIO otherwise you have a capability escalation
> path.

Seems more like for CAP_SYS_ADMIN, since it can affect other processes
than the one writing to the file.

> I'm not really in favour of this patch as is. It's not as flexible as
> doing it with a BPF filter which if we are going to have a new API is
> going to be cleaner, faster and has a clear understood API plus tools.
> 
> With BPF you can do things like enabling command A with option B on a
> specific device for a certain block range.

I liked the BPF idea, either with SCM_RIGHTS or cgroups, but I do wonder
if it's overengineered.  There are two uses for the filtering:

- non-privileged users who want to burn a CD or something like that.
For this, a bitmap is more than enough.  Customizing the bitmap lets
userspace fix the case of different meanings for the same byte value in
different SCSI standards.

- virtualization who wants to pass through almost everything, but still
run as confined as possible.  In this case a more complex filtering can
be done just as easily in userspace (i.e. QEMU).  Of course this means
the filter can be subverted if the guest can escape the QEMU jail, but
the "almost everything" takes care of that, for example you could still
block WRITE BUFFER commands.

I would be okay with a ioctl to disable the filter altogether (four
options: regular filter, no filter, no SG_IO at all, choose depending on
CAP_SYS_RAWIO).  Then you can use file descriptor passing with
SCM_RIGHTS, and do everything in userspace.  But it doesn't work too
well with the first usage above, besides being a larger patch.

Paolo
