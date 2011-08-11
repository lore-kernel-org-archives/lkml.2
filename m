Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741Ab1HKMr7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 08:47:59 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60904 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755556Ab1HKMr6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 08:47:58 -0400
MIME-Version: 1.0
In-Reply-To: <1313049724.11241.YahooMailNeo@web111704.mail.gq1.yahoo.com>
References: <1312872786.70934.YahooMailNeo@web111712.mail.gq1.yahoo.com>
 <1db776d865939be598cdb80054cf5d93.squirrel@xenotime.net> <1312874259.89770.YahooMailNeo@web111704.mail.gq1.yahoo.com>
 <alpine.DEB.2.00.1108090900170.30199@chino.kir.corp.google.com>
 <1312964098.7449.YahooMailNeo@web111712.mail.gq1.yahoo.com>
 <alpine.DEB.2.00.1108102106410.14230@chino.kir.corp.google.com>
 <1313046422.18195.YahooMailNeo@web111711.mail.gq1.yahoo.com>
 <alpine.DEB.2.00.1108110010220.23622@chino.kir.corp.google.com> <1313049724.11241.YahooMailNeo@web111704.mail.gq1.yahoo.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Thu, 11 Aug 2011 14:47:37 +0200
Message-ID: <CAK1hOcN7q=F=UV=aCAsVOYO=Ex34X0tbwLHv9BkYkA=ik7G13w@mail.gmail.com>
Subject: Re: running of out memory => kernel crash
To: Mahmood Naderan <nt_mahmood@yahoo.com>
Cc: David Rientjes <rientjes@google.com>, Randy Dunlap <rdunlap@xenotime.net>,
        "\"\"\"linux-kernel@vger.kernel.org\"\"\"" 
	<linux-kernel@vger.kernel.org>,
        "\"\"linux-mm@kvack.org\"\"" <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 11, 2011 at 10:02 AM, Mahmood Naderan <nt_mahmood@yahoo.com> wrote:
>>Despite it's name, kswapd is still active, it's trying to reclaim memory
>>to prevent having to kill a process as the last resort.
>
> I understand what you said, but I did two scenarios:
> 1- I wrote a simple C++ program that "new" a lot of pointers.
>    for ( int i = 0; i < n; i++ ) {
>      for ( int j = 0; j < n; j++ ) {
>        for ( int k = 0; k < n; k++ ) {
>          for ( int l = 0; l < n; l++ ) {
>            double *ptr1 = new double[n*i];
>            double *ptr2 = new double[n*j];
>      }}}}
>
> When I run the program, it ill eat the memory and when it reaches the
> maximum ram, it get killed and I saw  message on terminal:
>
> mahmood@vpc:~$ ./leak
> Killed
>
> for this scenario, there is no kswapd process running.

Why do you think kswapd should get active? What it can possibly do
if there is no swap and therefore it can't free memory by writing
out RAM pages to swap?

> 2- There is 300MB ram. I opened an application saw that
> free space reduced to 100MB, then another application reduced the free
> space to 30MB. Another application reduced to 4MB. Now the "kswapd"
> is running with a lot of disk activity and tries to keep free space at 4MB.
> In this scenario, No application is killed.
>
> The question is why in one scenario, the application is killed and in one
> scenario, kswapd is running.

In scenario 2, the disk activity comes from constant paging in (reading)
of pages which contain code of running binaries.

Since machine has no free RAM and no swap at all, when it needs
a free page it can't swap out a dirty (modified) page or anon
(usually malloced space) page. Thus the only option is to find some
not recently used page with read-only, file-backed content (usually some
binary's text page, but can be any read-only file mapping) and reuse it.

If there are no really old, unused read-only, file-backed pages,
then the discarded page will be needed soon, will need to be read from disk,
and will evict another similar page. Which will be needed soon too,
will need to be read from disk, and will evict another such page...
ad infinitum.

-- 
vda
