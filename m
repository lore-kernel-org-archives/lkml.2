Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872Ab1GAOj1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 10:39:27 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:54641 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756689Ab1GAOjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 10:39:25 -0400
MIME-Version: 1.0
In-Reply-To: <1309248717-14606-1-git-send-email-per.forlin@linaro.org>
References: <1309248717-14606-1-git-send-email-per.forlin@linaro.org>
Date: Fri, 1 Jul 2011 16:39:23 +0200
Message-ID: <BANLkTi=f1W=YGUkpTbOdHDhxgOvrHNYJ1w@mail.gmail.com>
Subject: Re: [PATCH v8 00/12] use nonblock mmc requests to minimize latency
From: Linus Walleij <linus.walleij@linaro.org>
To: Per Forlin <per.forlin@linaro.org>
Cc: linaro-dev@lists.linaro.org, Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org,
        Nickolay Nickolaev <nicknickolaev@gmail.com>,
        Venkatraman S <svenkatr@ti.com>, Chris Ball <cjb@laptop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 10:11 AM, Per Forlin <per.forlin@linaro.org> wrote:

> This is done by making the issue_rw_rq() non-blocking.
> The increase in throughput is proportional to the time it takes to
> prepare (major part of preparations is dma_map_sg and dma_unmap_sg)
> a request and how fast the memory is. The faster the MMC/SD is
> the more significant the prepare request time becomes. Measurements on U5500
> and Panda on eMMC and SD shows significant performance gain for large
> reads when running DMA mode. In the PIO case the performance is unchanged.

I compiled the patch set on top of latest mmc-next, had Per come over
to my desk and fix some test cases, then ran the new stress tests
on U300 plus mounted block device and performed read & write.

I found a bug in COH901318 DMA on the way and now the tests
runs run cleanly. (Patch will go to DMAengine maninainer Vinod.)

Test results below: conclusion is that not much performance is
gained on U300 with MMCI/PL180, this is because we have no
L2 cache, but we still get a small improvement of 1/2 to 1 s per test
case.

The code looks good too.

Tested/Acked-by: Linus Walleij <linus.walleij@linaro.org>

[  331.601747] mmc0: Starting tests of card mmc0:e624...
[  331.606902] mmc0: Test case 37. Write performance with blocking req
4k to 4MB...
[  378.117553] mmc0: Transfer of 32768 x 8 sectors (32768 x 4 KiB)
took 46.502646972 seconds (2886 kB/s, 2818 KiB/s, 704.64 IOPS, sg_len
1)
[  413.659600] mmc0: Transfer of 16384 x 16 sectors (16384 x 8 KiB)
took 35.529431000 seconds (3777 kB/s, 3689 KiB/s, 461.13 IOPS, sg_len
1)
[  443.270662] mmc0: Transfer of 8192 x 32 sectors (8192 x 16 KiB)
took 29.598359002 seconds (4534 kB/s, 4428 KiB/s, 276.77 IOPS, sg_len
1)
[  469.837460] mmc0: Transfer of 4096 x 64 sectors (4096 x 32 KiB)
took 26.554253999 seconds (5054 kB/s, 4936 KiB/s, 154.25 IOPS, sg_len
1)
[  497.702775] mmc0: Transfer of 2048 x 127 sectors (2048 x 63.5 KiB)
took 27.852746003 seconds (4818 kB/s, 4705 KiB/s, 73.52 IOPS, sg_len
1)
[  525.100160] mmc0: Transfer of 2048 x 127 sectors (2048 x 63.5 KiB)
took 27.384628001 seconds (4901 kB/s, 4786 KiB/s, 74.78 IOPS, sg_len
1)
[  552.955832] mmc0: Transfer of 2048 x 127 sectors (2048 x 63.5 KiB)
took 27.842956000 seconds (4820 kB/s, 4707 KiB/s, 73.55 IOPS, sg_len
1)
[  580.339398] mmc0: Transfer of 2048 x 127 sectors (2048 x 63.5 KiB)
took 27.370849000 seconds (4903 kB/s, 4788 KiB/s, 74.82 IOPS, sg_len
1)
[  607.985578] mmc0: Transfer of 2048 x 127 sectors (2048 x 63.5 KiB)
took 27.633430000 seconds (4857 kB/s, 4743 KiB/s, 74.11 IOPS, sg_len
1)
[  635.512579] mmc0: Transfer of 2048 x 127 sectors (2048 x 63.5 KiB)
took 27.514265002 seconds (4878 kB/s, 4763 KiB/s, 74.43 IOPS, sg_len
1)
[  635.525193] mmc0: Result: OK
[  635.528368] mmc0: Tests completed.
[  635.533104] mmc0: Starting tests of card mmc0:e624...
[  635.538244] mmc0: Test case 38. Write performance with non-blocking
req 4k to 4MB...
[  681.296218] mmc0: Transfer of 32768 x 8 sectors (32768 x 4 KiB)
took 45.749655000 seconds (2933 kB/s, 2864 KiB/s, 716.24 IOPS, sg_len
1)
[  716.089227] mmc0: Transfer of 16384 x 16 sectors (16384 x 8 KiB)
took 34.780447000 seconds (3858 kB/s, 3768 KiB/s, 471.06 IOPS, sg_len
1)
[  744.828042] mmc0: Transfer of 8192 x 32 sectors (8192 x 16 KiB)
took 28.726150001 seconds (4672 kB/s, 4562 KiB/s, 285.17 IOPS, sg_len
1)
[  771.174677] mmc0: Transfer of 4096 x 64 sectors (4096 x 32 KiB)
took 26.334063000 seconds (5096 kB/s, 4977 KiB/s, 155.53 IOPS, sg_len
1)
[  798.191207] mmc0: Transfer of 2048 x 127 sectors (2048 x 63.5 KiB)
took 27.003975000 seconds (4970 kB/s, 4853 KiB/s, 75.84 IOPS, sg_len
1)
[  825.588017] mmc0: Transfer of 2048 x 127 sectors (2048 x 63.5 KiB)
took 27.384043001 seconds (4901 kB/s, 4786 KiB/s, 74.78 IOPS, sg_len
1)
[  852.277635] mmc0: Transfer of 2048 x 127 sectors (2048 x 63.5 KiB)
took 26.676835000 seconds (5031 kB/s, 4913 KiB/s, 76.77 IOPS, sg_len
1)
[  879.488620] mmc0: Transfer of 2048 x 127 sectors (2048 x 63.5 KiB)
took 27.198205999 seconds (4934 kB/s, 4819 KiB/s, 75.29 IOPS, sg_len
1)
[  906.495492] mmc0: Transfer of 2048 x 127 sectors (2048 x 63.5 KiB)
took 26.994123001 seconds (4972 kB/s, 4855 KiB/s, 75.86 IOPS, sg_len
1)
[  933.427449] mmc0: Transfer of 2048 x 127 sectors (2048 x 63.5 KiB)
took 26.919235001 seconds (4985 kB/s, 4869 KiB/s, 76.07 IOPS, sg_len
1)
[  933.440075] mmc0: Result: OK
[  933.443247] mmc0: Tests completed.
[  933.447856] mmc0: Starting tests of card mmc0:e624...
[  933.453191] mmc0: Test case 39. Read performance with blocking req
4k to 4MB...
[  967.234708] mmc0: Transfer of 32768 x 8 sectors (32768 x 4 KiB)
took 33.773703000 seconds (3974 kB/s, 3880 KiB/s, 970.22 IOPS, sg_len
1)
[  991.857781] mmc0: Transfer of 16384 x 16 sectors (16384 x 8 KiB)
took 24.610504001 seconds (5453 kB/s, 5325 KiB/s, 665.73 IOPS, sg_len
1)
[ 1011.802479] mmc0: Transfer of 8192 x 32 sectors (8192 x 16 KiB)
took 19.932036000 seconds (6733 kB/s, 6575 KiB/s, 410.99 IOPS, sg_len
1)
[ 1029.388711] mmc0: Transfer of 4096 x 64 sectors (4096 x 32 KiB)
took 17.573680001 seconds (7637 kB/s, 7458 KiB/s, 233.07 IOPS, sg_len
1)
[ 1045.644443] mmc0: Transfer of 2048 x 127 sectors (2048 x 63.5 KiB)
took 16.243148000 seconds (8262 kB/s, 8069 KiB/s, 126.08 IOPS, sg_len
1)
[ 1061.899985] mmc0: Transfer of 2048 x 127 sectors (2048 x 63.5 KiB)
took 16.242733002 seconds (8263 kB/s, 8069 KiB/s, 126.08 IOPS, sg_len
1)
[ 1078.146701] mmc0: Transfer of 2048 x 127 sectors (2048 x 63.5 KiB)
took 16.233908999 seconds (8267 kB/s, 8073 KiB/s, 126.15 IOPS, sg_len
1)
[ 1094.402387] mmc0: Transfer of 2048 x 127 sectors (2048 x 63.5 KiB)
took 16.242875002 seconds (8263 kB/s, 8069 KiB/s, 126.08 IOPS, sg_len
1)
[ 1110.649158] mmc0: Transfer of 2048 x 127 sectors (2048 x 63.5 KiB)
took 16.233967999 seconds (8267 kB/s, 8073 KiB/s, 126.15 IOPS, sg_len
1)
[ 1126.905416] mmc0: Transfer of 2048 x 127 sectors (2048 x 63.5 KiB)
took 16.243438001 seconds (8262 kB/s, 8069 KiB/s, 126.08 IOPS, sg_len
1)
[ 1126.918129] mmc0: Result: OK
[ 1126.921358] mmc0: Tests completed.
[ 1126.925955] mmc0: Starting tests of card mmc0:e624...
[ 1126.931289] mmc0: Test case 40. Read performance with non-blocking
req 4k to 4MB...
[ 1159.685208] mmc0: Transfer of 32768 x 8 sectors (32768 x 4 KiB)
took 32.745868000 seconds (4098 kB/s, 4002 KiB/s, 1000.67 IOPS, sg_len
1)
[ 1183.516766] mmc0: Transfer of 16384 x 16 sectors (16384 x 8 KiB)
took 23.818903999 seconds (5634 kB/s, 5502 KiB/s, 687.85 IOPS, sg_len
1)
[ 1202.827382] mmc0: Transfer of 8192 x 32 sectors (8192 x 16 KiB)
took 19.297962001 seconds (6955 kB/s, 6792 KiB/s, 424.50 IOPS, sg_len
1)
[ 1219.886157] mmc0: Transfer of 4096 x 64 sectors (4096 x 32 KiB)
took 17.046200000 seconds (7873 kB/s, 7689 KiB/s, 240.28 IOPS, sg_len
1)
[ 1235.638313] mmc0: Transfer of 2048 x 127 sectors (2048 x 63.5 KiB)
took 15.739587001 seconds (8527 kB/s, 8327 KiB/s, 130.11 IOPS, sg_len
1)
[ 1251.391234] mmc0: Transfer of 2048 x 127 sectors (2048 x 63.5 KiB)
took 15.740097000 seconds (8526 kB/s, 8327 KiB/s, 130.11 IOPS, sg_len
1)
[ 1267.143799] mmc0: Transfer of 2048 x 127 sectors (2048 x 63.5 KiB)
took 15.739750001 seconds (8527 kB/s, 8327 KiB/s, 130.11 IOPS, sg_len
1)
[ 1282.896571] mmc0: Transfer of 2048 x 127 sectors (2048 x 63.5 KiB)
took 15.739964000 seconds (8527 kB/s, 8327 KiB/s, 130.11 IOPS, sg_len
1)
[ 1298.649986] mmc0: Transfer of 2048 x 127 sectors (2048 x 63.5 KiB)
took 15.740602001 seconds (8526 kB/s, 8326 KiB/s, 130.10 IOPS, sg_len
1)
[ 1314.394199] mmc0: Transfer of 2048 x 127 sectors (2048 x 63.5 KiB)
took 15.731410000 seconds (8531 kB/s, 8331 KiB/s, 130.18 IOPS, sg_len
1)
[ 1314.406920] mmc0: Result: OK
[ 1314.410167] mmc0: Tests completed.
[ 1314.414783] mmc0: Starting tests of card mmc0:e624...
[ 1314.420123] mmc0: Test case 41. Write performance blocking req 1 to
512 sg elems...
[ 1342.241715] mmc0: Transfer of 2048 x 127 sectors (2048 x 63.5 KiB)
took 27.813536000 seconds (4825 kB/s, 4712 KiB/s, 73.63 IOPS, sg_len
1)
[ 1369.319673] mmc0: Transfer of 2048 x 127 sectors (2048 x 63.5 KiB)
took 27.065227999 seconds (4958 kB/s, 4842 KiB/s, 75.66 IOPS, sg_len
8)
[ 1396.773703] mmc0: Transfer of 2048 x 127 sectors (2048 x 63.5 KiB)
took 27.441285001 seconds (4891 kB/s, 4776 KiB/s, 74.63 IOPS, sg_len
16)
[ 1423.675432] mmc0: Transfer of 2048 x 127 sectors (2048 x 63.5 KiB)
took 26.888910001 seconds (4991 kB/s, 4874 KiB/s, 76.16 IOPS, sg_len
16)
[ 1451.239203] mmc0: Transfer of 2048 x 127 sectors (2048 x 63.5 KiB)
took 27.550955999 seconds (4871 kB/s, 4757 KiB/s, 74.33 IOPS, sg_len
16)
[ 1478.262309] mmc0: Transfer of 2048 x 127 sectors (2048 x 63.5 KiB)
took 27.010269002 seconds (4969 kB/s, 4852 KiB/s, 75.82 IOPS, sg_len
16)
[ 1505.491671] mmc0: Transfer of 2048 x 127 sectors (2048 x 63.5 KiB)
took 27.216503001 seconds (4931 kB/s, 4815 KiB/s, 75.24 IOPS, sg_len
16)
[ 1532.747882] mmc0: Transfer of 2048 x 127 sectors (2048 x 63.5 KiB)
took 27.243356999 seconds (4926 kB/s, 4811 KiB/s, 75.17 IOPS, sg_len
16)
[ 1532.760607] mmc0: Result: OK
[ 1532.763779] mmc0: Tests completed.
[ 1532.768387] mmc0: Starting tests of card mmc0:e624...
[ 1532.773722] mmc0: Test case 42. Write performance non-blocking req
1 to 512 sg elems...
[ 1559.686860] mmc0: Transfer of 2048 x 127 sectors (2048 x 63.5 KiB)
took 26.904625000 seconds (4988 kB/s, 4871 KiB/s, 76.12 IOPS, sg_len
1)
[ 1586.632702] mmc0: Transfer of 2048 x 127 sectors (2048 x 63.5 KiB)
took 26.933068001 seconds (4983 kB/s, 4866 KiB/s, 76.04 IOPS, sg_len
8)
[ 1613.014844] mmc0: Transfer of 2048 x 127 sectors (2048 x 63.5 KiB)
took 26.369411000 seconds (5089 kB/s, 4970 KiB/s, 77.66 IOPS, sg_len
16)
[ 1640.120694] mmc0: Transfer of 2048 x 127 sectors (2048 x 63.5 KiB)
took 27.092996001 seconds (4953 kB/s, 4837 KiB/s, 75.59 IOPS, sg_len
16)
[ 1666.593943] mmc0: Transfer of 2048 x 127 sectors (2048 x 63.5 KiB)
took 26.460398000 seconds (5072 kB/s, 4953 KiB/s, 77.39 IOPS, sg_len
16)
[ 1693.477690] mmc0: Transfer of 2048 x 127 sectors (2048 x 63.5 KiB)
took 26.870933000 seconds (4994 kB/s, 4877 KiB/s, 76.21 IOPS, sg_len
16)
[ 1719.918133] mmc0: Transfer of 2048 x 127 sectors (2048 x 63.5 KiB)
took 26.427604001 seconds (5078 kB/s, 4959 KiB/s, 77.49 IOPS, sg_len
16)
[ 1746.761038] mmc0: Transfer of 2048 x 127 sectors (2048 x 63.5 KiB)
took 26.830035002 seconds (5002 kB/s, 4885 KiB/s, 76.33 IOPS, sg_len
16)
[ 1746.773743] mmc0: Result: OK
[ 1746.776905] mmc0: Tests completed.
[ 1746.781603] mmc0: Starting tests of card mmc0:e624...
[ 1746.786742] mmc0: Test case 43. Read performance blocking req 1 to
512 sg elems...
[ 1763.028662] mmc0: Transfer of 2048 x 127 sectors (2048 x 63.5 KiB)
took 16.233791001 seconds (8267 kB/s, 8073 KiB/s, 126.15 IOPS, sg_len
1)
[ 1779.313875] mmc0: Transfer of 2048 x 127 sectors (2048 x 63.5 KiB)
took 16.272372001 seconds (8248 kB/s, 8054 KiB/s, 125.85 IOPS, sg_len
8)
[ 1795.625488] mmc0: Transfer of 2048 x 127 sectors (2048 x 63.5 KiB)
took 16.298793000 seconds (8234 kB/s, 8041 KiB/s, 125.65 IOPS, sg_len
16)
[ 1811.937588] mmc0: Transfer of 2048 x 127 sectors (2048 x 63.5 KiB)
took 16.299186000 seconds (8234 kB/s, 8041 KiB/s, 125.65 IOPS, sg_len
16)
[ 1828.249349] mmc0: Transfer of 2048 x 127 sectors (2048 x 63.5 KiB)
took 16.298847000 seconds (8234 kB/s, 8041 KiB/s, 125.65 IOPS, sg_len
16)
[ 1844.561499] mmc0: Transfer of 2048 x 127 sectors (2048 x 63.5 KiB)
took 16.299234002 seconds (8234 kB/s, 8041 KiB/s, 125.65 IOPS, sg_len
16)
[ 1860.864668] mmc0: Transfer of 2048 x 127 sectors (2048 x 63.5 KiB)
took 16.290268999 seconds (8239 kB/s, 8045 KiB/s, 125.71 IOPS, sg_len
16)
[ 1877.177045] mmc0: Transfer of 2048 x 127 sectors (2048 x 63.5 KiB)
took 16.299461001 seconds (8234 kB/s, 8041 KiB/s, 125.64 IOPS, sg_len
16)
[ 1877.189848] mmc0: Result: OK
[ 1877.193031] mmc0: Tests completed.
[ 1877.197628] mmc0: Starting tests of card mmc0:e624...
[ 1877.202958] mmc0: Test case 44. Read performance non-blocking req 1
to 512 sg elems...
[ 1892.939499] mmc0: Transfer of 2048 x 127 sectors (2048 x 63.5 KiB)
took 15.728134000 seconds (8533 kB/s, 8333 KiB/s, 130.21 IOPS, sg_len
1)
[ 1908.693056] mmc0: Transfer of 2048 x 127 sectors (2048 x 63.5 KiB)
took 15.740710002 seconds (8526 kB/s, 8326 KiB/s, 130.10 IOPS, sg_len
8)
[ 1924.437735] mmc0: Transfer of 2048 x 127 sectors (2048 x 63.5 KiB)
took 15.731847999 seconds (8531 kB/s, 8331 KiB/s, 130.18 IOPS, sg_len
16)
[ 1940.190363] mmc0: Transfer of 2048 x 127 sectors (2048 x 63.5 KiB)
took 15.739700003 seconds (8527 kB/s, 8327 KiB/s, 130.11 IOPS, sg_len
16)
[ 1955.935298] mmc0: Transfer of 2048 x 127 sectors (2048 x 63.5 KiB)
took 15.732027999 seconds (8531 kB/s, 8331 KiB/s, 130.18 IOPS, sg_len
16)
[ 1971.688298] mmc0: Transfer of 2048 x 127 sectors (2048 x 63.5 KiB)
took 15.740083001 seconds (8526 kB/s, 8327 KiB/s, 130.11 IOPS, sg_len
16)
[ 1987.441782] mmc0: Transfer of 2048 x 127 sectors (2048 x 63.5 KiB)
took 15.740559000 seconds (8526 kB/s, 8326 KiB/s, 130.10 IOPS, sg_len
16)
[ 2003.195375] mmc0: Transfer of 2048 x 127 sectors (2048 x 63.5 KiB)
took 15.740680001 seconds (8526 kB/s, 8326 KiB/s, 130.10 IOPS, sg_len
16)
[ 2003.208170] mmc0: Result: OK
[ 2003.211401] mmc0: Tests completed.

Yours,
Linus Walleij
