Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031391Ab2CFVKK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 16:10:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43820 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031126Ab2CFVKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 16:10:07 -0500
Message-ID: <4F567D23.9040309@canonical.com>
Date: Tue, 06 Mar 2012 16:09:55 -0500
From: Joseph Salisbury <joseph.salisbury@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120302 Thunderbird/11.0
MIME-Version: 1.0
To: viro@zeniv.linux.org.uk, eparis@redhat.com
CC: hirofumi@mail.parknet.co.jp, john@johnmccutchan.com, rlove@rlove.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Race inotify_rm_watch vs umount
References: <87r572nd9k.fsf@devron.myhome.or.jp> <1307713566.2577.20.camel@localhost.localdomain> <20110610143550.GZ11521@ZenIV.linux.org.uk> <CAGHUO11rNGU9VMAPQNdXtpQeAixFX6zxJc-tWur1McqbpYpYpQ@mail.gmail.com>
In-Reply-To: <CAGHUO11rNGU9VMAPQNdXtpQeAixFX6zxJc-tWur1McqbpYpYpQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2012 04:02 PM, Joseph Salisbury wrote:
>
>
> Forwarded conversation
> Subject: *Race inotify_rm_watch vs umount*
> ------------------------
>
> From: *OGAWA Hirofumi* <hirofumi@mail.parknet.co.jp
> <mailto:hirofumi@mail.parknet.co.jp>>
> Date: Fri, Jun 10, 2011 at 7:20 AM
> To: John McCutchan <john@johnmccutchan.com
> <mailto:john@johnmccutchan.com>>, Robert Love <rlove@rlove.org
> <mailto:rlove@rlove.org>>, Eric Paris <eparis@redhat.com
> <mailto:eparis@redhat.com>>
> Cc: linux-kernel@vger.kernel.org <mailto:linux-kernel@vger.kernel.org>,
> linux-fsdevel@vger.kernel.org <mailto:linux-fsdevel@vger.kernel.org>
>
>
> Hi,
>
> I'm looking the race inotify_rm_watch() vs umount(). This race become the
> cause of Oops. You can see the oops at
>
> https://bugzilla.kernel.org/show_bug.cgi?id=22602
>
> So, what race?
>
> umount                               inotify_rm_watch
>   ...                                  fsnotify_destroy_mark()
>                                          fsnotify_destroy_inode_mark()
>                                            /* removed from
> i_fsnotify_marks */
>     generic_shutdown_super()
>       fsnotify_unmount_inodes()
>         put_super()
>                                            iput()
>                                              iput_final()
>                                                /* this is after
> put_super() */
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
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp
> <mailto:hirofumi@mail.parknet.co.jp>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> <mailto:majordomo@vger.kernel.org>
> More majordomo info at http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at http://www.tux.org/lkml/
>
> ----------
> From: *Eric Paris* <eparis@redhat.com <mailto:eparis@redhat.com>>
> Date: Fri, Jun 10, 2011 at 9:46 AM
> To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp
> <mailto:hirofumi@mail.parknet.co.jp>>
> Cc: John McCutchan <john@johnmccutchan.com
> <mailto:john@johnmccutchan.com>>, Robert Love <rlove@rlove.org
> <mailto:rlove@rlove.org>>, linux-kernel@vger.kernel.org
> <mailto:linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
> <mailto:linux-fsdevel@vger.kernel.org>
>
>
> Ok, I see what you are saying, I'll see what I can do.  I'm a little
> scared to call something like iput() under a lock though.  I might be
> able to make the bigest lock a mutex and fix this....
>
> I'll add this to my test suite.
>
> -Eric
>  >
>  > umount                               inotify_rm_watch
>  >   ...                                  fsnotify_destroy_mark()
>  >                                          fsnotify_destroy_inode_mark()
>  >                                            /* removed from
> i_fsnotify_marks */
>  >     generic_shutdown_super()
>  >       fsnotify_unmount_inodes()
>  >         put_super()
>  >                                            iput()
>  >                                              iput_final()
>  >                                                /* this is after
> put_super() */
>  >
>  > Like above, inotify doesn't guarantee to call final iput() before
>  > put_super(). With this violation, FS driver can oops.
>  >
>  > Well, so, what are requested for inotify?  We can't simply take
>  > sb->s_umount in inotify_rm_watch()?
>  >
>  > Any ideas?
>  >
>  > Thanks.
>
>
> --
>
> ----------
> From: *Al Viro* <viro@zeniv.linux.org.uk <mailto:viro@zeniv.linux.org.uk>>
> Date: Fri, Jun 10, 2011 at 10:35 AM
> To: Eric Paris <eparis@redhat.com <mailto:eparis@redhat.com>>
> Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp
> <mailto:hirofumi@mail.parknet.co.jp>>, John McCutchan
> <john@johnmccutchan.com <mailto:john@johnmccutchan.com>>, Robert Love
> <rlove@rlove.org <mailto:rlove@rlove.org>>, linux-kernel@vger.kernel.org
> <mailto:linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
> <mailto:linux-fsdevel@vger.kernel.org>
>
>
> Which lock would that be?  I don't see any good candidates in there...
>
>

Hello,

It appears this bug still exists in the 3.2 kernel[0].  There was some 
discussion about this bug in this thread and in the bug[1].  However, 
there haven't been any updates in a while.

Has there been any further findings on this issue?

Thanks,

Joe


[0] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/922906
[1] https://bugzilla.kernel.org/show_bug.cgi?id=22602
