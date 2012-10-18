Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902Ab2JRV2t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 17:28:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53556 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752080Ab2JRV2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 17:28:47 -0400
Date: Thu, 18 Oct 2012 23:28:45 +0200
From: Jan Kara <jack@suse.cz>
To: Alex Bligh <alex@alex.org.uk>
Cc: Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org
Subject: Re: Local DoS through write heavy I/O on CFQ & Deadline
Message-ID: <20121018212845.GB17646@quack.suse.cz>
References: <0B138F62-16BF-4295-9AD9-64C0BB39FCE2@alex.org.uk>
 <20121012133044.GA10115@dhcp22.suse.cz>
 <E6EF14955C67D6CA58918872@nimrod.local>
 <20121012145838.GD22083@dhcp22.suse.cz>
 <3D1C85A52BB960B79E37AC30@nimrod.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3D1C85A52BB960B79E37AC30@nimrod.local>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

On Fri 12-10-12 17:29:50, Alex Bligh wrote:
> --On 12 October 2012 16:58:39 +0200 Michal Hocko <mhocko@suse.cz> wrote:
  Let me explain a couple of things...

> >Once dirty_ratio (resp. dirty_bytes) limit is hit then the process which
> >writes gets throttled. If this is not the case then there is a bug in
> >the throttling code.
> I believe that is the problem.
  So I believe the throttling works. What write throttling does is that it
throttles process when more than dirty_bytes (or dirty_ratio) memory would
become dirty. That clearly works as otherwise your testcase will drive the
machine out of memory. Now whenever some memory is cleaned by writeback,
your process is allowed to continue so there is always enough data to
write.

Actually, the throttling is somewhat more clever and doesn't allow a dirty
hog (like your dd test) to use all of the dirtiable limit. Instead the hog
is throttled somewhat earlier leaving some dirtiable memory to other
processes as well. Seeing that mysql process gets blocked during fsync(2)
(and not during write itself) this mechanism works right as well.

> >>Isn't the only thing that is going to change that it ends up
> >>triggering the writeback earlier?
> >
> >Set the limit lowe?
> 
> I think you mean 'lower'. If I do that, what I think will happen
> is that it will start the write-back earlier, but the writeback
> once started will not keep up with the generation of data, possibly
> because the throttling isn't going to work. Note that for
> instance using ionice to set priority or class to 'idle'
> has no effect. So, to test my hypothesis ...
  Yeah, ionice has its limitations. The problem is that all buffered
writes happen just into memory (so completely independently of ionice
settings). Subsequent writing of dirty memory to disk happens using flusher
thread which is a kernel process and it doesn't know anything about IO
priority set for task which created the file. If you wrote the file with
oflag=direct or oflag=sync you would see that ionice works as expected.

Now what *is* your problem is an ext4 behavior (proper list CCed) as David
Chinner correctly noted. Apparently journal thread is not able to commit
transaction for a long time. I've tried to reproduce your results
(admittedly with replacing myslq with a simplistic "dd if=/dev/zero of=file2
bs=1M count=1 conv=fsync") but I failed. fsync always returns in a couple
of seconds... What ext4 mount options do you use?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
