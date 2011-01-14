Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971Ab1ANQi2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 11:38:28 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38203 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757650Ab1ANQiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 11:38:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=N4UP42ijpg7psEuhBGLFp3roBREuJgKCv8kbvQBJfYylwOXVLvTKPpLvC137eKHqlb
         ZrDM3+trEODxY5vQ5ilS8DfL2JSY1K+VY0IzzrhnM9488MHgKN4ghqOXTYUms/afxJJe
         LL69xaO1fRmqJlaS9CRTq7lZc1p2K79lUpXg8=
Date: Fri, 14 Jan 2011 17:29:19 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Dave Anderson <anderson@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] /proc/kcore: fix seeking
Message-ID: <20110114162914.GA1782@nowhere>
References: <4D2B1AD5.9000707@redhat.com>
 <20110111160437.GF17312@hack>
 <20110111162317.GA1703@nowhere>
 <20110114094442.GB10219@cr0.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110114094442.GB10219@cr0.nay.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 05:44:42PM +0800, Américo Wang wrote:
> On Tue, Jan 11, 2011 at 05:23:23PM +0100, Frederic Weisbecker wrote:
> >On Wed, Jan 12, 2011 at 12:04:37AM +0800, Américo Wang wrote:
> >> On Mon, Jan 10, 2011 at 09:42:29AM -0500, Dave Anderson wrote:
> >> >From: Dave Anderson <anderson@redhat.com>
> >> >
> >> >Commit 34aacb2920667d405a8df15968b7f71ba46c8f18
> >> >("procfs: Use generic_file_llseek in /proc/kcore")
> >> >broke seeking on /proc/kcore.  This changes it back
> >> >to use default_llseek in order to restore the original
> >> >behavior.
> >> >
> >> >The problem with generic_file_llseek is that it only
> >> >allows seeks up to inode->i_sb->s_maxbytes, which is
> >> >2GB-1 on procfs, where the memory file offset values in
> >> >the /proc/kcore PT_LOAD segments may exceed or start
> >> >beyond that offset value.
> >> >
> >> 
> >> Is the race solved? Using default_llseek() still races
> >> with read_kcore() on fpos, AFAIK.
> >
> >Hmm, how does it race there?
> >
> >read_kcore() manipulates fpos, which can't be changed behind
> >us inside the read callback as it's a snapshot. Also read_kcore()
> >can change the value of fpos, which is writed back to file->fpos
> >from sys_read().
> >
> >So the last resulting race here the natural one between
> >seeking and reading, which is up to the user to take care
> >of.
> 
> Hmm, I just read the changelog of commit
> 34aacb2920667d405a8df15968b7f71ba46c8f18, which claims to fix
> the race. So anything changed in vfs layer after that?


Ah it didn't fix any race, it just got rid of the bkl, OTOH
I said in my changelog:

	"/proc/kcore has no llseek and then falls down to use default_llseek.
	This is racy against read_kcore() that directly manipulates fpos
	but it doesn't hold the bkl there so using it in llseek doesn't
	protect anything."

So I think this just testifies my crude misunderstanding of the code when I wrote
that changelog. I didn't realize fpos is a copy of the file offset that is writed back
later. Hence my changelog was buggy.
