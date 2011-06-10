Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202Ab1FJNqM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 09:46:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755261Ab1FJNqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 09:46:10 -0400
Subject: Re: Race inotify_rm_watch vs umount
From: Eric Paris <eparis@redhat.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Date: Fri, 10 Jun 2011 09:46:05 -0400
In-Reply-To: <87r572nd9k.fsf@devron.myhome.or.jp>
References: <87r572nd9k.fsf@devron.myhome.or.jp>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1307713566.2577.20.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-10 at 20:20 +0900, OGAWA Hirofumi wrote:
> Hi,
> 
> I'm looking the race inotify_rm_watch() vs umount(). This race become the
> cause of Oops. You can see the oops at
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=22602
> 
> So, what race?

Ok, I see what you are saying, I'll see what I can do.  I'm a little
scared to call something like iput() under a lock though.  I might be
able to make the bigest lock a mutex and fix this....

I'll add this to my test suite.

-Eric
> 
> umount                               inotify_rm_watch
>   ...                                  fsnotify_destroy_mark()
>                                          fsnotify_destroy_inode_mark()
>                                            /* removed from i_fsnotify_marks */
>     generic_shutdown_super()
>       fsnotify_unmount_inodes()
>         put_super()
>                                            iput()
>                                              iput_final()
>                                                /* this is after put_super() */
> 
> Like above, inotify doesn't guarantee to call final iput() before
> put_super(). With this violation, FS driver can oops.
> 
> Well, so, what are requested for inotify?  We can't simply take
> sb->s_umount in inotify_rm_watch()?
> 
> Any ideas?
> 
> Thanks.


