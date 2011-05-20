Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934825Ab1ETISb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 04:18:31 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61670 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934559Ab1ETIS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 04:18:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=szeredi.hu; s=google;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=C0WCMG8WzB7cLFw7FKe0SBK8/Gqn8u8kF3YtRs4fqZAXBxHpHKWgR3bkMt3VOQNLJu
         LyKS3iAC0lyyvmhxQdYFPZ8n5TZpMCuvQm30SH1dImrLh+qR2JiBiXFeS/+Q5JdrZGkM
         poZ9VYUeGF5HevbvrFFZ4BFCYs3OjRfGeUr2w=
From: Miklos Szeredi <miklos@szeredi.hu>
To: NeilBrown <neilb@suse.de>
Cc: Andy Whitcroft <apw@canonical.com>, viro@ZenIV.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, nbd@openwrt.org, hramrach@centrum.cz,
        jordipujolp@gmail.com
Subject: Re: [PATCH 0/7] overlay filesystem v9
References: <1305635452-14835-1-git-send-email-miklos@szeredi.hu>
	<20110519163709.GH3702@shadowen.org>
	<87sjsak2jt.fsf@tucsk.pomaz.szeredi.hu>
	<20110519180558.GJ3702@shadowen.org>
	<20110520081226.0787e2dd@notabene.brown>
Date: Fri, 20 May 2011 10:18:30 +0200
In-Reply-To: <20110520081226.0787e2dd@notabene.brown> (NeilBrown's message of
	"Fri, 20 May 2011 08:12:26 +1000")
Message-ID: <87ipt5vl7t.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Neil, sorry for the dup)

NeilBrown <neilb@suse.de> writes:

> On Thu, 19 May 2011 19:05:58 +0100 Andy Whitcroft <apw@canonical.com> wrote:
>
>> On Thu, May 19, 2011 at 07:44:54PM +0200, Miklos Szeredi wrote:
>> > I'd be happier if the LSM module were fixed not to peek inside the inode
>> > structure.  Some filesystems (notably network ones) do not guarantee i_*
>> > to be up-to-date, relying on these is not a good idea.
>> 
>> I wonder what what the official way to get ownership information for an
>> inode is if we cannot rely on those.  I am happy to get the Yama LSM
>> fixed up if they are doing something wrong.
>> 
>> -apw
>
> inode->getattr(...., &kstat);
> look at kstat.uid, kstat.gid.

Yeah, it should probably do something like:

	if (inode->i_op->getattr) {
		struct kstat stat;
		inode->i_op->getattr(...)
		uid = stat.uid;
	} else {
		uid = inode->i_uid;
	}

The problem is that getattr takes a vfsmount, which makes this
impossible to do cleanly.  And the solution is for ->getattr() to lose
that argument, which is a bit more involved :(

Thanks,
Miklos
