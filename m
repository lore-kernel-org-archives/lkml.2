Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932372Ab1AKQXc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 11:23:32 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48078 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932242Ab1AKQXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 11:23:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=Y+lr2kOHwFMUDI9qgLxHAC0mzqDy5MwK+mnhO4brFHiVsdEjGpjCZBcTmzW64WL7+e
         qDYrZinJ8DmyJwXQFGXRvevhO87YWxPvYmuWPbZB7eTa2S06be5lia1Bb0kENLfF4+a+
         CUiwWbUEDuCPdINVuHbmKKdLqduxUQ572W30Q=
Date: Tue, 11 Jan 2011 17:23:23 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Dave Anderson <anderson@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] /proc/kcore: fix seeking
Message-ID: <20110111162317.GA1703@nowhere>
References: <4D2B1AD5.9000707@redhat.com>
 <20110111160437.GF17312@hack>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110111160437.GF17312@hack>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 12:04:37AM +0800, Américo Wang wrote:
> On Mon, Jan 10, 2011 at 09:42:29AM -0500, Dave Anderson wrote:
> >From: Dave Anderson <anderson@redhat.com>
> >
> >Commit 34aacb2920667d405a8df15968b7f71ba46c8f18
> >("procfs: Use generic_file_llseek in /proc/kcore")
> >broke seeking on /proc/kcore.  This changes it back
> >to use default_llseek in order to restore the original
> >behavior.
> >
> >The problem with generic_file_llseek is that it only
> >allows seeks up to inode->i_sb->s_maxbytes, which is
> >2GB-1 on procfs, where the memory file offset values in
> >the /proc/kcore PT_LOAD segments may exceed or start
> >beyond that offset value.
> >
> 
> Is the race solved? Using default_llseek() still races
> with read_kcore() on fpos, AFAIK.

Hmm, how does it race there?

read_kcore() manipulates fpos, which can't be changed behind
us inside the read callback as it's a snapshot. Also read_kcore()
can change the value of fpos, which is writed back to file->fpos
from sys_read().

So the last resulting race here the natural one between
seeking and reading, which is up to the user to take care
of.

Or am I missing something?
