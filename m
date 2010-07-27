Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486Ab0G0Ht3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 03:49:29 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:58156 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040Ab0G0Ht2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 03:49:28 -0400
Date: Tue, 27 Jul 2010 09:48:54 +0200
From: Heinz Diehl <htd@fancy-poultry.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
        jaxboe@fusionio.com, nauman@google.com, dpshah@google.com,
        guijianfeng@cn.fujitsu.com, jmoyer@redhat.com, czoccolo@gmail.com
Subject: Re: [RFC PATCH] cfq-iosched: IOPS mode for group scheduling and new
 group_idle tunable
Message-ID: <20100727074854.GA8077@fritha.org>
References: <1279834172-4227-1-git-send-email-vgoyal@redhat.com>
 <20100723140343.GA8478@fancy-poultry.org>
 <20100723141303.GB13104@redhat.com>
 <20100723145631.GA8844@fancy-poultry.org>
 <20100723183720.GD13104@redhat.com>
 <20100724080613.GA6554@fancy-poultry.org>
 <20100726141330.GA1621@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100726141330.GA1621@infradead.org>
X-Accept-Language: no,dk,se,en,de
Organization: private site
X-OpenPGP-KeyID: 0xA9353F12
X-OpenPGP-Fingerprint: C67E 9A93 1033 DF8A 9321  9F90 DC39 B8C3 A935 3F12
X-OpenPGP-URL: http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.20+20100619 (GNU/Linux)
X-Provags-ID: V02:K0:v1caCLiLGuhtFPy4hG1SeYut1DJpsuoyOgDREUlPJ8q
 jZCLJJgZOCJSdv7oFUwBVjtSgE1Sx02trErmpzy9fIAatpebqE
 Zroagb3c+CtIzOeP4Op2ca6Tq0+gCa22DHUCaqw/vtXPYWo6UI
 8Pl5RCjd+VfMp95Q0Gne5RLimVsOu56hEzJzHPil1BuxeWSjbj
 C05GOaELkHtmoefnWVWeg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.07.2010, Christoph Hellwig wrote: 

> Just curious, what numbers do you see when simply using the deadline
> I/O scheduler?  That's what we recommend for use with XFS anyway.

Some fs_mark testing first:

Deadline, 1 thread:

#  ./fs_mark  -S  1  -D  10000  -N  100000  -d  /home/htd/fsmark/test  -s  65536  -t  1  -w  4096  -F 

FSUse%        Count         Size    Files/sec     App Overhead
    26         1000        65536        227.7            39998
    26         2000        65536        229.2            39309
    26         3000        65536        236.4            40232
    26         4000        65536        231.1            39294
    26         5000        65536        233.4            39728
    26         6000        65536        234.2            39719
    26         7000        65536        227.9            39463
    26         8000        65536        239.0            39477
    26         9000        65536        233.1            39563
    26        10000        65536        233.1            39878
    26        11000        65536        233.2            39560

Deadline, 4 threads:

#  ./fs_mark  -S  1  -D  10000  -N  100000  -d  /home/htd/fsmark/test  -s  65536  -t  4  -w  4096  -F 

FSUse%        Count         Size    Files/sec     App Overhead
    26         4000        65536        465.6           148470
    26         8000        65536        398.6           152827
    26        12000        65536        472.7           147235
    26        16000        65536        477.0           149344
    27        20000        65536        489.7           148055
    27        24000        65536        444.3           152806
    27        28000        65536        515.5           144821
    27        32000        65536        501.0           146561
    27        36000        65536        456.8           150124
    27        40000        65536        427.8           148830
    27        44000        65536        489.6           149843
    27        48000        65536        467.8           147501


CFQ, 1 thread:

#  ./fs_mark  -S  1  -D  10000  -N  100000  -d  /home/htd/fsmark/test  -s  65536  -t  1  -w  4096  -F 

FSUse%        Count         Size    Files/sec     App Overhead
    27         1000        65536        439.3            30158
    27         2000        65536        457.7            30274
    27         3000        65536        432.0            30572
    27         4000        65536        413.9            29641
    27         5000        65536        410.4            30289
    27         6000        65536        458.5            29861
    27         7000        65536        441.1            30268
    27         8000        65536        459.3            28900
    27         9000        65536        420.1            30439
    27        10000        65536        426.1            30628
    27        11000        65536        479.7            30058

CFQ, 4 threads:

#  ./fs_mark  -S  1  -D  10000  -N  100000  -d  /home/htd/fsmark/test  -s  65536  -t  4  -w  4096  -F 

FSUse%        Count         Size    Files/sec     App Overhead
    27         4000        65536        540.7           149177
    27         8000        65536        469.6           147957
    27        12000        65536        507.6           149185
    27        16000        65536        460.0           145953
    28        20000        65536        534.3           151936
    28        24000        65536        542.1           147083
    28        28000        65536        516.0           149363
    28        32000        65536        534.3           148655
    28        36000        65536        511.1           146989
    28        40000        65536        499.9           147884
    28        44000        65536        514.3           147846
    28        48000        65536        467.1           148099
    28        52000        65536        454.7           149052


Here are the results of the fsync-tester, doing

 "while : ; do time sh -c "dd if=/dev/zero of=bigfile bs=8M count=256 ;
 sync; rm bigfile"; done"
 
in the background on the root fs and running fsync-tester on /home.

Deadline:

liesel:~/test # ./fsync-tester
fsync time: 7.7866
fsync time: 9.5638
fsync time: 5.8163
fsync time: 5.5412
fsync time: 5.2630
fsync time: 8.6688
fsync time: 3.9947
fsync time: 5.4753
fsync time: 14.7666
fsync time: 4.0060
fsync time: 3.9231
fsync time: 4.0635
fsync time: 1.6129
^C

CFQ:

liesel:/home/htd/fs # liesel:~/test # ./fsync-tester
fsync time: 0.2457
fsync time: 0.3045
fsync time: 0.1980
fsync time: 0.2011
fsync time: 0.1941
fsync time: 0.2580
fsync time: 0.2041
fsync time: 0.2671
fsync time: 0.0320
fsync time: 0.2372
^C

The same setup here, running both the "bigfile torture test" and
fsync-tester on /home:

Deadline:

htd@liesel:~/fs> ./fsync-tester
fsync time: 11.0455
fsync time: 18.3555
fsync time: 6.8022
fsync time: 14.2020
fsync time: 9.4786
fsync time: 10.3002
fsync time: 7.2607
fsync time: 8.2169
fsync time: 3.7805
fsync time: 7.0325
fsync time: 12.0827
^C


CFQ:
htd@liesel:~/fs> ./fsync-tester
fsync time: 13.1126
fsync time: 4.9432
fsync time: 4.7833
fsync time: 0.2117
fsync time: 0.0167
fsync time: 14.6472
fsync time: 10.7527
fsync time: 4.3230
fsync time: 0.0151
fsync time: 15.1668
fsync time: 10.7662
fsync time: 0.1670
fsync time: 0.0156
^C

All partitions are XFS formatted using

 mkfs.xfs -f -l lazy-count=1,version=2 -i attr=2 -d agcount=4

and mounted that way:

 (rw,noatime,logbsize=256k,logbufs=2,nobarrier)

Kernel is 2.6.35-rc6.


Thanks, Heinz.

