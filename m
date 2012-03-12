Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599Ab2CLCAv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 22:00:51 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:65326 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610Ab2CLCAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 22:00:44 -0400
Date: Mon, 12 Mar 2012 10:06:09 +0800
From: Zheng Liu <gnehzuil.liu@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: linux-mm <linux-mm@kvack.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>, riel@redhat.com,
        kosaki.motohiro@jp.fujitsu.com
Subject: Re: Fwd: Control page reclaim granularity
Message-ID: <20120312020609.GA9610@gmail.com>
Mail-Followup-To: Minchan Kim <minchan@kernel.org>,
	linux-mm <linux-mm@kvack.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Konstantin Khlebnikov <khlebnikov@openvz.org>, riel@redhat.com,
	kosaki.motohiro@jp.fujitsu.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120312002806.GA2436@barrios>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 09:29:34AM +0900, Minchan Kim wrote:
> I forgot to Ccing you.
> Sorry.
> 
> ---------- Forwarded message ----------
> From: Minchan Kim <minchan@kernel.org>
> Date: Mon, Mar 12, 2012 at 9:28 AM
> Subject: Re: Control page reclaim granularity
> To: Minchan Kim <minchan@kernel.org>, linux-mm <linux-mm@kvack.org>,
> linux-kernel <linux-kernel@vger.kernel.org>, Konstantin Khlebnikov <
> khlebnikov@openvz.org>, riel@redhat.com, kosaki.motohiro@jp.fujitsu.com
> 
> 
> On Fri, Mar 09, 2012 at 12:54:03AM +0800, Zheng Liu wrote:
> > Hi Minchan,
> >
> > Sorry, I forgot to say that I don't subscribe linux-mm and linux-kernel
> > mailing list.  So please Cc me.
> >
> > IMHO, maybe we should re-think about how does user use mmap(2).  I
> > describe the cases I known in our product system.  They can be
> > categorized into two cases.  One is mmaped all data files into memory
> > and sometime it uses write(2) to append some data, and another uses
> > mmap(2)/munmap(2) and read(2)/write(2) to manipulate the files.  In the
> > second case,  the application wants to keep mmaped page into memory and
> > let file pages to be reclaimed firstly.  So, IMO, when application uses
> > mmap(2) to manipulate files, it is possible to imply that it wants keep
> > these mmaped pages into memory and do not be reclaimed.  At least these
> > pages do not be reclaimed early than file pages.  I think that maybe we
> > can recover that routine and provide a sysctl parameter to let the user
> > to set this ratio between mmaped pages and file pages.
> 
> I am not convinced why we should handle mapped page specially.
> Sometimem, someone may use mmap by reducing buffer copy compared to read
> system call.
> So I think we can't make sure mmaped pages are always win.
> 
> My suggestion is that it would be better to declare by user explicitly.
> I think we can implement it by madvise and fadvise's WILLNEED option.
> Current implementation is just readahead if there isn't a page in memory
> but I think
> we can promote from inactive to active if there is already a page in
> memory.
> 
> It's more clear and it couldn't be affected by kernel page reclaim
> algorithm change
> like this.

Thank you for your advice.  But I still have question about this
solution.  If we improve the madvise(2) and fadvise(2)'s WILLNEED
option,  it will cause an inconsistently status for pages that be
manipulated by madvise(2) and/or fadvise(2).  For example, when I call
madvise with WILLNEED flag, some pages will be moved into active list if
they already have been in memory, and other pages will be read into
memory and be saved in inactive list if they don't be in memory.  Then
pages that are in inactive list are possible to be reclaim.  So from the
view of users, it is inconsistent because some pages are in memory and
some pages are reclaimed.  But actually the user hopes that all of pages
can be kept in memory.  IMHO, this inconsistency is weird and makes users
puzzled.

Regards,
Zheng
