Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421Ab0DTVBk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 17:01:40 -0400
Received: from mail.lug-erding.de ([89.110.147.240]:46720 "EHLO
	mail.lug-erding.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755403Ab0DTVBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 17:01:37 -0400
X-Greylist: delayed 577 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Apr 2010 17:01:37 EDT
Date: Tue, 20 Apr 2010 22:51:44 +0200
From: Dirk Geschke <dirk@lug-erding.de>
To: linux-kernel@vger.kernel.org
Cc: dirk@lug-erding.de
Subject: Re: Should calculation of vm.overcommit_ratio be changed?
Message-ID: <20100420205144.GA7875@lug-erding.de>
Mail-Followup-To: Dirk Geschke <geschke@lug-erding.de>,
	linux-kernel@vger.kernel.org, dirk@lug-erding.de
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-LUG-Erding-MailScanner: Found to be clean
X-LUG-Erding-MailScanner-From: geschke@mail.lug-erding.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I am not on the mailing list and a friend pointed me to this
thread...

Probably we had the same problem: We had a linux computer with
16 GB of RAM without swap. There was only one big job running
on it which did a lot of I/O. This program failed to allocate
much memory, we thought that this was due to the high amount
of cached memory use. To avoid problems with overcommit we had
set overcommit_memory to 2.

Now I have seen this thread and now it gets clear: The default
value of overcommit_ratio is 50, therefore one program can not
allocate more than 8GB of memory at all.

After reading this thread I wrote a little programm to allocate
memory in 512MB blocks and fill it with zeros. My test system
has 4GB of RAM and so I started:

qfix:~# free
             total       used       free     shared    buffers     cached
Mem:       4052376     338124    3714252          0          0      17992
-/+ buffers/cache:     320132    3732244
Swap:            0          0          0

geschke@qfix:~$ ./a.out
got 1 * 512MB
got 2 * 512MB
got 3 * 512MB
malloc failure after 3 * 512 MB

So 1.5 GB are ok, 2 GB of possible 4GB not. I guess some memory of
the 4GB are not useable at all and therefore the limit is slightly
below 2GB with an overcommit_ratio=50.

Next step is to set overcommit_ratio=100:

qfix:~# echo 100 >/proc/sys/vm/overcommit_ratio

and run the porgram again:

geschke@qfix:~$ ./a.out
got 1 * 512MB
got 2 * 512MB
got 3 * 512MB
got 4 * 512MB
got 5 * 512MB
got 6 * 512MB
malloc failure after 6 * 512 MB

That are more than 3 GB but I would have expected to get at least
3.5GB:

geschke@qfix:~$ free
             total       used       free     shared    buffers     cached
Mem:       4052376     344976    3707400          0          0      22472
-/+ buffers/cache:     322504    3729872
Swap:            0          0          0

Maybe this is due to a reserved percentage for the root user?

However, if I set overcommit_ratio=110 I get more than 3.5 GB:

geschke@qfix:~$ ./a.out
got 1 * 512MB
got 2 * 512MB
got 3 * 512MB
got 4 * 512MB
got 5 * 512MB
got 6 * 512MB
got 7 * 512MB
malloc failure after 7 * 512 MB

However, now I tested this with a high usage of cached memory, I
die a lot of I/O:

geschke@qfix:~$ free
             total       used       free     shared    buffers     cached
Mem:       4052376    1945512    2106864          0          0    1621200
-/+ buffers/cache:     324312    3728064
Swap:            0          0          0

A new run gives:

geschke@qfix:~$ ./a.out
got 1 * 512MB
got 2 * 512MB
got 3 * 512MB
got 4 * 512MB
got 5 * 512MB
got 6 * 512MB
got 7 * 512MB
malloc failure after 7 * 512 MB

and:

qfix:~# free
             total       used       free     shared    buffers     cached
Mem:       4052376     346928    3705448          0          0      26008
-/+ buffers/cache:     320920    3731456
Swap:            0          0          0

So the cached memory is not really a problem for malloc.

But since I am testing, I tried what will happens if a lot of memory
is already in use. So I opened a large file with "vi":

geschke@qfix:~$ free
             total       used       free     shared    buffers     cached
Mem:       4052376    1597168    2455208          0          0     391364
-/+ buffers/cache:    1205804    2846572
Swap:            0          0          0

Now I start the program again:

geschke@qfix:~$ ./a.out
got 1 * 512MB
got 2 * 512MB
got 3 * 512MB
got 4 * 512MB
got 5 * 512MB
malloc failure after 5 * 512 MB

Fine: It seems that there is not really a problem to increase to
overcommit_ratio=100 if there is no swap in the system and one
has set overcommit_memory=2.

So I think, it is not really a problem to run with these settings.

Best regards

Dirk
-- 
+----------------------------------------------------------------------+
| Dr. Dirk Geschke       / Plankensteinweg 61    / 85435 Erding        |
| Telefon: 08122-559448  / Mobil: 0176-96906350 / Fax: 08122-9818106   |
| dirk@geschke-online.de / dirk@lug-erding.de  / kontakt@lug-erding.de | 
+----------------------------------------------------------------------+
