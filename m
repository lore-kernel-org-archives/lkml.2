Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760008Ab2CGUd1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 15:33:27 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33885 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758083Ab2CGUd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 15:33:26 -0500
Message-ID: <4F57C610.8050101@openvz.org>
Date: Thu, 08 Mar 2012 00:33:20 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120217 Firefox/10.0.2 Iceape/2.7.2
MIME-Version: 1.0
To: Zheng Liu <gnehzuil.liu@gmail.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Fine granularity page reclaim
References: <20120217092205.GA9462@gmail.com>	<4F3EB675.9030702@openvz.org> <20120220062006.GA5028@gmail.com>	<4F41F1C2.3030908@openvz.org> <CANWLp03njY11Swiic7_mv6Gk3C=v4YYe5nLzbAjLH0KftyQftA@mail.gmail.com>
In-Reply-To: <CANWLp03njY11Swiic7_mv6Gk3C=v4YYe5nLzbAjLH0KftyQftA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zheng Liu wrote:
>
>
> On Monday, February 20, 2012, Konstantin Khlebnikov <khlebnikov@openvz.org <mailto:khlebnikov@openvz.org>> wrote:
>  > Zheng Liu wrote:
>  >>
>  >> Cc linux-kernel mailing list.
>  >>
>  >> On Sat, Feb 18, 2012 at 12:20:05AM +0400, Konstantin Khlebnikov wrote:
>  >>>
>  >>> Zheng Liu wrote:
>  >>>>
>  >>>> Hi all,
>  >>>>
>  >>>> Currently, we encounter a problem about page reclaim. In our product system,
>  >>>> there is a lot of applictions that manipulate a number of files. In these
>  >>>> files, they can be divided into two categories. One is index file, another is
>  >>>> block file. The number of index files is about 15,000, and the number of
>  >>>> block files is about 23,000 in a 2TB disk. The application accesses index
>  >>>> file using mmap(2), and read/write block file using pread(2)/pwrite(2). We hope
>  >>>> to hold index file in memory as much as possible, and it works well in Redhat
>  >>>> 2.6.18-164. It is about 60-70% of index files that can be hold in memory.
>  >>>> However, it doesn't work well in Redhat 2.6.32-133. I know in 2.6.18 that the
>  >>>> linux uses an active list and an inactive list to handle page reclaim, and in
>  >>>> 2.6.32 that they are divided into anonymous list and file list. So I am
>  >>>> curious about why most of index files can be hold in 2.6.18? The index file
>  >>>> should be replaced because mmap doesn't impact the lru list.
>  >>>
>  >>> There was my patch for fixing similar problem with shared/executable mapped pages
>  >>> "vmscan: promote shared file mapped pages" commit 34dbc67a644f and commit c909e99364c
>  >>> maybe it will help in your case.
>  >>
>  >> Hi Konstantin,
>  >>
>  >> Thank you for your reply.  I have tested it in upstream kernel.  These
>  >> patches are useful for multi-processes applications.  But, in our product
>  >> system, there are some applications that are multi-thread.  So
>  >> 'references_ptes>  1' cannot help these applications to hold the data in
>  >> memory.
>  >
>  > Ok, what if you mmap you data as executable, just to test.
>  > Then these pages will be activated after first touch.
>  > In attachment patch with per-mm flag with the same effect.
>  >
>
> Hi Konstantin,
>
> Sorry for the delay reply.  Last two weeks I was trying these two solutions
> and evaluating the impacts for the performance in our product system.
> Good news is that these two solutions both work well. They can keep
> mapped files in memory under mult-thread.  But I have a question for
> the first solution (map the file with PROT_EXEC flag).  I think this way is
> too tricky.  As I said previously, these files that needs to be mapped only
> are normal index file, and they shouldn't be mapped with PROT_EXEC flag
> from the view of an application programmer.  So actually the key issue is
> that we should provide a mechanism, which lets different file sets can be
> reclaimed separately.  I am not sure whether this idea is useful or not.  So
> any feedbacks are welcomed.:-).  Thank you.
>

Sounds good. Yes, PROT_EXEC isn't very usable and secure, per-mm flag not
very flexible too. I prefer setting some kind of memory pressure priorities
for each vma and inode. Probably we can sort vma and inodes into different
cgroup-like sets and balance memory pressure between them.
Maybe someone was thought about it...
