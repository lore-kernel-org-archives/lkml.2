Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972Ab0HXUtE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 16:49:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21902 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755618Ab0HXUtC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 16:49:02 -0400
Date: Tue, 24 Aug 2010 16:48:39 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: Neil Brown <neilb@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 14/39] union-mount: Union mounts documentation
Message-ID: <20100824204839.GB28718@shell>
References: <1281282776-5447-1-git-send-email-vaurora@redhat.com> <1281282776-5447-15-git-send-email-vaurora@redhat.com> <20100810085641.2b9a714c@notabene> <20100817204430.GE5556@shell> <6820.1282094632@jrobl> <20100818185542.GA10850@shell> <16318.1282181699@jrobl> <20100824000505.GA20909@shell> <6881.1282616917@jrobl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6881.1282616917@jrobl>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 11:28:37AM +0900, J. R. Okajima wrote:
> 
> Thank you for explanation, very much.

You are welcome!

> When a rename happens on a layer directly, aufs receives a
> inotify/fsnotify event. Following the event type, aufs makes the cached
> dentry/inode obsoleted and they will be lookup-ed again in the
> succeeding access. Finally aufs will know the upper parent_dir1 is not
> covering the lower parent_dir2 anymore.
> This notification is the main purpose of the strict option which is
> called "udba=notify" (User's Direct Branch Access).

No, that's not a sufficient description and leaves open questions
about all sorts of deadlocks and race conditions.  For example,
inotify events occur while holding locks only on one layer.  You
obviously need to lock the top layer to update the inheritance and
parent-child relationships.  Now you are locking the lower layer first
and the top layer second, which is the reverse of the usual order.
Also, it should not be an option.

If Al Viro says it's wrong, you need a very detailed explanation of
why it is right.  See Documentation/filesystem/directory-locking for
an example of the argument you have to make to show that moving things
around on the lower layer is safe.  In general, your first task is to
show a global lock ordering to prove lack of deadlocks (which I don't
think you should spend time on because most VFS experts think it is
impossible to do with two read-write layers).

I'm not going to explain any more how aufs is wrong; it's the
maintainer's job to convince Al Viro and other maintainers that aufs
is right.  But I hope this gave you a start and showed why union
mounts is a preferred approach for many people.

Thanks,

-VAL
