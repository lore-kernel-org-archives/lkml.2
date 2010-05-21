Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934263Ab0EURNb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 13:13:31 -0400
Received: from n4-vm0.bullet.mail.gq1.yahoo.com ([67.195.9.7]:44576 "HELO
	n4-vm0.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933527Ab0EURN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 13:13:29 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 786736.37626.bm@omp107.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=3V1JDGOJ9Ngh+WtTfmmJz7boKndWFnlI6utD6bKsX/cvpf4ahgJdYN1U46mtoWLKFN2r3VrbupldEdNgTkxr09nRJS1hMcP2yUdE3reRxkKo3TypEgB5VCGBCco0G5wvVJ8G5s3qA9OvsMFDOjYDPN0HKR3GbfynNso0K5quJUM=;
Message-ID: <604382.53147.qm@web114319.mail.gq1.yahoo.com>
X-YMail-OSG: V9jPLxgVM1nGkpRAl0udeTlDc1YWJdAyU.uPwbHMXh05Lwm
 eu_NzqPw6NGetgZTc5W7ZzuIfMlcMAJYBRoMii..PA_OVYfE9Vr_X2B8Ceaj
 wL4wEImPRLs1qnRRqRIJQ5nvKnqvIFU5eozXAqrFXgDHDgsq9V3qG6ZljZ5b
 SUCpZE81p8II5G4hzBhxjUmc1Ew556poLGKYLGUBngEX2xNjccOiKaXL0dIc
 AENym8DQg6i5g_bl0kBmtdXhGwyWwJoMQXhGREZZdAiqxtIHW5q8Q2yxM9vm
 kAdmCk7_t0GjQHmqkY8o-
X-Mailer: YahooMailClassic/11.0.8 YahooMailWebService/0.8.103.269680
Date: Fri, 21 May 2010 10:13:28 -0700 (PDT)
From: Rick Sherm <rick.sherm@yahoo.com>
Subject: Re: [patch] pipe: add support for shrinking and growing pipes
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <20100520174855.GV25951@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Thu, 5/20/10, Jens Axboe <jens.axboe@oracle.com>  wrote:

> Yeah, I'd say his 4x results pretty much speak for
> themselves. I've
> observed splice being slower as well here for high
> bandwidth testing,
> the 64kb max buffer size ends up hurting there. So I'm very
> convinced
> that this is a good idea. I have been for a while, was just
> waiting for
> someone else to pop up with an independent need and results
> to help
> shove it in :-)
>

I see a very minor reduction in CPU usage(used same code referenced in this < http://marc.info/?l=linux-kernel&m=127143736527459&w=2 > thread but with new fcntl args):


I'm attempting a 1G file-to-file copy:

Case1) O_DIRECT copy
time ./pcap_file_to_file direct 2048
0.000u 0.200s 0:01.93 10.3%     0+0k 2097176+2097152io 0pf+0w

==========================
iostat -d /dev/sdb1 -x 1
==========================
Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sdb1              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sdb1              0.00     0.00    7.00    0.00  4096.00     0.00   585.14     0.13   17.71   3.86   2.70

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sdb1              0.00     0.00 1947.00 1949.00 1137816.00 1139072.00   584.42     5.18    1.33   0.25  96.70

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sdb1              0.00     0.00 1633.00 1641.00 955264.00 958848.00   584.64     4.87    1.49   0.26  86.50

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sdb1              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00


Case2) with new fcntl-splice calls:

2.1) splice: 64 pipe buffers
tcsh# time ./pcap_splice_2_splice direct 2048 64
0.008u 3.137s 0:07.38 42.4%     0+0k 2097176+2097152io 0pf+0w

==========================
iostat -d /dev/sdb1 -x 1
==========================
Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sdb1              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sdb1              0.00  3397.00  257.00 1141.00 65048.00 129024.00   138.82     0.38    0.27   0.19  25.90

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sdb1              0.00 15733.00 1153.00 5027.00 295168.00 590464.00   143.31     0.96    0.16   0.13  81.30

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sdb1              0.00 15123.00 1093.00 4552.00 279808.00 559744.00   148.72     0.88    0.16   0.14  76.70

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sdb1              0.00 14163.00 1025.00 4296.00 262400.00 525056.00   147.99     0.93    0.18   0.15  80.40

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sdb1              0.00 14866.00 1074.00 4464.00 274944.00 549632.00   148.89     0.91    0.16   0.14  79.40

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sdb1              0.00 15169.00 1098.00 4596.00 281088.00 562304.00   148.12     0.93    0.16   0.14  79.50

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sdb1              0.00 16299.00 1216.00 5581.00 311296.00 622464.00   137.38     0.93    0.14   0.11  77.80

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sdb1              0.00 15505.00 1162.00 5418.00 297472.00 594944.00   135.63     0.92    0.14   0.12  77.10

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sdb1              0.00  1596.00  117.00  530.00 29952.00 60672.00   140.07     0.08    0.13   0.11   7.10

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sdb1              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00


2.2) splice: 256 pipe buffers
tcsh# time ./pcap_splice_2_splice direct 2048 256

0.002u 3.149s 0:07.52 41.7%     0+0k 2097176+2097152io 0pf+0w

==========================
iostat -d /dev/sdb1 -x 1
==========================
Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sdb1              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sdb1              0.00  8022.00  606.00 2817.00 154392.00 308224.00   135.15     0.66    0.19   0.14  47.70

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sdb1              0.00 15958.00 1201.00 5662.00 307456.00 614938.00   134.40     1.02    0.15   0.12  83.40

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sdb1              0.00 15877.00 1170.00 5173.00 299520.00 598656.00   141.60     0.93    0.15   0.12  78.70

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sdb1              0.00 14945.00 1075.00 4415.00 275200.00 550784.00   150.45     0.97    0.18   0.15  84.30

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sdb1              0.00 14796.00 1066.00 4399.00 272896.00 545792.00   149.81     0.93    0.17   0.15  80.10

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sdb1              0.00 13767.00  993.00 4090.00 254208.00 508032.00   149.96     0.95    0.17   0.17  84.40

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sdb1              0.00 14830.00 1068.00 4404.00 273408.00 547200.00   149.96     0.94    0.18   0.15  82.80

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sdb1              0.00 14113.00 1016.00 4193.00 260096.00 520704.00   149.89     0.93    0.18   0.16  81.70

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sdb1              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00


2.3) 512 pipe-buffers

tcsh# time ./pcap_splice_2_splice direct 2048 512
0.005u 3.222s 0:06.91 46.5%     0+0k 2097176+2097152io 0pf+0w


Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sdb1              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sdb1              0.00     0.00    0.00    1.00     0.00    16.00    16.00     0.00    0.00   0.00   0.00

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sdb1              0.00  4687.00  352.00 1576.00 89368.00 178048.00   138.70     0.40    0.21   0.15  28.80

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sdb1              0.00 15265.00 1133.00 5124.00 290048.00 579985.00   139.05     0.91    0.15   0.11  71.60

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sdb1              0.00 15080.00 1094.00 4621.00 280064.00 560384.00   147.06     0.70    0.12   0.12  66.10

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sdb1              0.00 16200.00 1189.00 5201.00 304384.00 608640.00   142.88     0.78    0.12   0.11  72.50

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sdb1              0.00 17009.00 1246.00 5419.00 318976.00 637952.00   143.58     0.75    0.11   0.10  69.10

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sdb1              0.00 16014.00 1170.00 5038.00 299520.00 598912.00   144.72     0.75    0.12   0.11  70.20

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sdb1              0.00 17363.00 1268.00 5470.00 324608.00 649472.00   144.57     0.74    0.11   0.10  66.90

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sdb1              0.00 10231.00  743.00 3161.00 190208.00 380928.00   146.30     0.44    0.11   0.10  40.50

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sdb1              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00



      

