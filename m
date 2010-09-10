Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab0IJT4K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 15:56:10 -0400
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:41462 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753036Ab0IJT4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 15:56:08 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: JkLCNa0VM1nAZgOVxnTMhSp4IQMlmzwfilmuFVvIv0ddyVq
 WZlGRfVo5VufYT0KksnDyiOLIj7iVbtzDjy5UwGixmTLtaA4HlMvjMqjAZl.
 2oSdLAmddPCdTQzQTv_H8s_RtrY5jq8KC_KaDDOiXUcNGahPkNrnNZbcr7wK
 .AiDVyztI1cs8sGwyfhm9TL9IsBZPturvY8mrbMqUPxRj0wP3ZyEKDy0lB1w
 sXOAK.jjNOZGAOO.URjDUryC0MZ_AyO7Z6I0tF06Wb5ikLx0BfdAeBS4w1dX
 sYwcnszeh5sBx5b3.5svJtj0-
X-Yahoo-Newman-Property: ymail-3
Subject: Re: [RFC 02/22] configfs: Add struct
	configfs_item_operations->check_link() in configfs_unlink()
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Joel Becker <Joel.Becker@oracle.com>
Cc: Konrad Rzeszutek Wilk <konrad@darnok.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        James Bottomley <James.Bottomley@suse.de>,
        Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <bharrosh@panasas.com>,
        Linux-fsdevel <linux-fsdevel@vger.kernel.org>
In-Reply-To: <20100910194404.GJ885@mail.oracle.com>
References: <1283160025-6598-1-git-send-email-nab@linux-iscsi.org>
	 <20100902064814.GB27904@mail.oracle.com>
	 <1283456440.5598.108.camel@haakon2.linux-iscsi.org>
	 <201009071701.02847.konrad@darnok.org>
	 <20100907224413.GC21935@mail.oracle.com>
	 <1283911739.556.420.camel@haakon2.linux-iscsi.org>
	 <20100908192639.GD29545@mail.oracle.com>
	 <1283979207.556.510.camel@haakon2.linux-iscsi.org>
	 <20100910152802.GG885@mail.oracle.com>
	 <1284145606.19890.68.camel@haakon2.linux-iscsi.org>
	 <20100910194404.GJ885@mail.oracle.com>
Content-Type: text/plain
Date: Fri, 10 Sep 2010 12:52:03 -0700
Message-Id: <1284148323.19890.94.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-10 at 12:44 -0700, Joel Becker wrote:
> On Fri, Sep 10, 2010 at 12:06:46PM -0700, Nicholas A. Bellinger wrote:
> > On Fri, 2010-09-10 at 08:28 -0700, Joel Becker wrote:
> > > 	The trivial solution is to refcount your ACLs.  You get both
> > > allow_link() calls, so you should be able to increment a counter there,
> > > and then drop them when the last drop_link() call is made.  That will
> > > keep your consumer structures around until all links are exhausted.
> > > 
> > 
> > So I am a bit confused wrt to this last response..  The ->check_link()
> > patch and it's use in the fabric independent code within
> > target_core_fabric_configfs.c does exactly this for the 'MappedLUN'
> > symlink case, eg: requires the consumer to do the allow_link() +
> > drop_link() refcounting, and add the
> > API check into fs/configfs/symlink.c:configfs_unlink()
> 
> 	You can refcount without check_link().

So what do you recommend here..?

>  
> > Is there another form of configfs consumer refcounting that you had in
> > mind beyond using an atomic_t for this with ->check_link() here..?
> 
> 	I'm saying that you won't crash if you don't free the ACLs on
> the first drop_link().  That is, the drop_link() goes through as
> configfs wants it to, but you don't crash.

The problem is that the 'unlink sub_child/group1/src_0/src_link' can't
signal to the other struct config_group to also call an internal 'unlink
sub_child/group2/dst_0/dst_link' to drop the child link outside of it's
struct config_group.

> 
> > So beyond a configfs consumer solution, what do you think about checking
> > for the sub_child/group2/dst_0/dst_link style of symlink
> > in fs/configfs/symlink.c:configfs_symlink() in order to add some form of
> > internal refcount when the symlink source is within the same consumer
> > LKM, but outside of the parent struct config_group..?
> > 
> > This would involve the conversion of fs/configfs/symlink.c:
> > configfs_unlink() path to check for the existence of this internal
> > refcount and returning -EPERM when any sub_child/group2/dst_0/dst_link
> > exist when 'unlink sub_child/group1/src_0/src_link' is attempted.
> 
> 	You're still fighting allowing the links to go away.  You
> haven't explained why that is necessary.  You had a problem with a crash
> because you expected one reference to your ACLs and actually have two,
> but you can fix that without modifying configfs.

If this is the case then I must be mis-understanding what you mean by
configfs consumer refcounting from allow_link() and drop_link().  Can
you give me a bit more detail where I should be looking..?

Thanks!

--nab


