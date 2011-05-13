Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150Ab1EMIqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 04:46:18 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58580 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758104Ab1EMIqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 04:46:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mVBf8FVpPvzMavsjxUeXUVW8369vKB7hW8F2OPkk9CFSExnqHoz63hCdVIkCOxk+bL
         muZgNoiOZlWOx4e4+4+dxXBvbXeI5z1wTfs0Hmk3MfXhMpJvT4QLZTTuVF4jMtgEBxHz
         9dC/IapIJ8OZwBjfZveHa9euynMfgd0T93TPg=
Date: Fri, 13 May 2011 10:46:11 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 09/11] job control: reorganize wait_task_stopped()
Message-ID: <20110513084611.GB6500@htj.dyndns.org>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <1304869745-1073-10-git-send-email-tj@kernel.org>
 <20110511154854.GB23688@redhat.com>
 <20110511192902.GC24245@mtj.dyndns.org>
 <20110512154247.GC18599@redhat.com>
 <20110512160253.GK1030@htj.dyndns.org>
 <20110512172506.GA23033@redhat.com>
 <20110512173228.GO1030@htj.dyndns.org>
 <20110512183326.GA26042@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110512183326.GA26042@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, May 12, 2011 at 08:33:26PM +0200, Oleg Nesterov wrote:
> Damn, you are right, I think.

Yay, for once!

> At first glance, do_wait() does
> 
> 	wait_task_stopped();
> 	wait_task_continued();
> 
> and the state can be changed CONTINIUED -> STOPPED in between, right?
> Or something else?

Yeah and exit transitions too.  There simply is no synchronization
there.  We can probably solve it without acquiring siglock by adding
"clear this before making state transitions" flag followed by a mb()
and then making children clear it before transitions.  Then, we can
retry WNOHANG wait if the flag is cleared after checking.

Thanks.

-- 
tejun
