Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843Ab0KWNzi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 08:55:38 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:48979 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab0KWNzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 08:55:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:in-reply-to:references:user-agent:date
         :message-id:mime-version:content-type;
        b=Tg4AEQB9us+ifg+gwtrXNMwsY+Cpn8RRp4KXZo0MUWYpPhotB2d3X8xe0eGYRHo2C7
         k8UbjHd8eZQLK/rCi+wDi96lL1BFi0a+UVANHOl6as220WrgikijtUcCaNgLcynU93g4
         GLf1Yz67OwFl3R4wnpKQklQn1mZOTHBHCT8k8=
From: Ben Gamari <bgamari@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: kosaki.motohiro@jp.fujitsu.com, Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@kernel.dk>
Subject: Re: [RFC 1/2] deactive invalidated pages
In-Reply-To: <20101122103756.E236.A69D9226@jp.fujitsu.com>
References: <bdd6628e81c06f6871983c971d91160fca3f8b5e.1290349672.git.minchan.kim@gmail.com> <874obawvlt.fsf@gmail.com> <20101122103756.E236.A69D9226@jp.fujitsu.com>
User-Agent: Notmuch/0.5-3-g22aadfc (http://notmuchmail.org) Emacs/23.1.1 (x86_64-pc-linux-gnu)
Date: Tue, 23 Nov 2010 08:48:53 -0500
Message-ID: <87mxp09mm2.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Nov 2010 16:16:55 +0900 (JST), KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> > On Sun, 21 Nov 2010 23:30:23 +0900, Minchan Kim <minchan.kim@gmail.com> wrote:
> > > 
> > > Ben, Remain thing is to modify rsync and use
> > > fadvise(POSIX_FADV_DONTNEED). Could you test it?
> > 
> > Thanks a ton for the patch. Looks good. Testing as we speak.
> 
For the record, this was a little premature. As I spoke the kernel was
building but I still haven't had a chance to take any data. Any
suggestions for how to determine the effect (or hopefully lack thereof)
of rsync on the system's working set?

> If possible, can you please post your rsync patch and your testcase
> (or your rsync option + system memory size info + data size info)?
> 
Patch coming right up.

The original test case is a backup script for my home directory. rsync
is invoked with,

rsync --archive --update --progress --delete --delete-excluded
--exclude-from=~/.backup/exclude --log-file=~/.backup/rsync.log -e ssh
/home/ben ben@myserver:/mnt/backup/current

My home directory is 120 GB with typical delta sizes of tens of
megabytes between backups (although sometimes deltas can be gigabytes,
after which the server has severe interactivity issues). The server is
unfortunately quite memory constrained with only 1.5GB of memory (old
inherited hardware). Given the size of my typical deltas, I'm worried
that even simply walking the directory hierarchy might be enough to push
out my working set.

Looking at the rsync access pattern with strace it seems that it does
a very good job of avoid duplicate reads which is good news for these
patches.

Cheers,

- Ben


