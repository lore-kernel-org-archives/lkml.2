Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab0DSLqG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 07:46:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46095 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752431Ab0DSLqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 07:46:04 -0400
Subject: Re: CFQ read performance regression
From: Miklos Szeredi <mszeredi@suse.cz>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
       Suresh Jayaraman <sjayaraman@suse.de>
In-Reply-To: <h2m4e5e476b1004170546z8997cd90h98ecfb9cc5aad8cf@mail.gmail.com>
References: <1271420878.24780.145.camel@tucsk.pomaz.szeredi.hu>
	 <h2m4e5e476b1004170546z8997cd90h98ecfb9cc5aad8cf@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Apr 2010 13:46:02 +0200
Message-ID: <1271677562.24780.184.camel@tucsk.pomaz.szeredi.hu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Corrado,

On Sat, 2010-04-17 at 14:46 +0200, Corrado Zoccolo wrote:
> I don't think this is related to CFQ. I've made a graph of the
> accessed (read) sectors (see attached).
> You can see that the green cloud (2.6.16) is much more concentrated,
> while the red one (2.6.32) is split in two, and you can better
> recognize the different lines.
> This means that the FS put more distance between the blocks of the
> files written by the tio threads, and the read time is therefore
> impacted, since the disk head has to perform longer seeks. On the
> other hand, if you read those files sequentially with a single thread,
> the performance may be better with the new layout, so YMMV. When
> testing 2.6.32 and up, you should consider testing also with
> low_latency setting disabled, since tuning for latency can negatively
> affect throughput.

low_latency is set to zero in all tests.

The layout difference doesn't explain why setting the scheduler to
"noop" consistently speeds up read throughput in 8-thread tiobench to
almost twice.  This fact alone pretty clearly indicates that the I/O
scheduler is the culprit.

There are other indications, see the attached btt output for both
traces.  From there it appears that 2.6.16 does more and longer seeks,
yet it's getting an overall better performance.

I've also tested with plain "dd" instead of tiobench where the
filesystem layout stayed exactly the same between tests.  Still the
speed difference is there.

Thanks,
Miklos

************************************************************************
btt output for 2.6.16:
==================== All Devices ====================

            ALL           MIN           AVG           MAX           N
--------------- ------------- ------------- ------------- -----------

Q2Q               0.000000047   0.000854417   1.003550405       67465
Q2G               0.000000458   0.000001211   0.000123527       46062
G2I               0.000000123   0.000001815   0.000494517       46074
Q2M               0.000000186   0.000001798   0.000010296       21404
I2D               0.000000162   0.000158001   0.040794333       46062
M2D               0.000000878   0.000133130   0.040585566       21404
D2C               0.000053870   0.023778266   0.234154543       67466
Q2C               0.000056746   0.023931014   0.234176000       67466

==================== Device Overhead ====================

       DEV |       Q2G       G2I       Q2M       I2D       D2C
---------- | --------- --------- --------- --------- ---------
 (  8, 64) |   0.0035%   0.0052%   0.0024%   0.4508%  99.3617%
---------- | --------- --------- --------- --------- ---------
   Overall |   0.0035%   0.0052%   0.0024%   0.4508%  99.3617%

==================== Device Merge Information ====================

       DEV |       #Q       #D   Ratio |   BLKmin   BLKavg   BLKmax    Total
---------- | -------- -------- ------- | -------- -------- -------- --------
 (  8, 64) |    67466    46062     1.5 |        8      597     1024 27543688

==================== Device Q2Q Seek Information ====================

       DEV |          NSEEKS            MEAN          MEDIAN | MODE           
---------- | --------------- --------------- --------------- | ---------------
 (  8, 64) |           67466        866834.0               0 | 0(34558)
---------- | --------------- --------------- --------------- | ---------------
   Overall |          NSEEKS            MEAN          MEDIAN | MODE           
   Average |           67466        866834.0               0 | 0(34558)

==================== Device D2D Seek Information ====================

       DEV |          NSEEKS            MEAN          MEDIAN | MODE           
---------- | --------------- --------------- --------------- | ---------------
 (  8, 64) |           46062       1265503.9               0 | 0(13242)
---------- | --------------- --------------- --------------- | ---------------
   Overall |          NSEEKS            MEAN          MEDIAN | MODE           
   Average |           46062       1265503.9               0 | 0(13242)

==================== Plug Information ====================

       DEV |    # Plugs # Timer Us  | % Time Q Plugged
---------- | ---------- ----------  | ----------------
 (  8, 64) |      29271(       533) |   3.878105328%

       DEV |    IOs/Unp   IOs/Unp(to)
---------- | ----------   ----------
 (  8, 64) |       19.2         19.7
---------- | ----------   ----------
   Overall |    IOs/Unp   IOs/Unp(to)
   Average |       19.2         19.7

==================== Active Requests At Q Information ====================

       DEV |  Avg Reqs @ Q
---------- | -------------
 (  8, 64) |           0.8

==================== I/O Active Period Information ====================

       DEV |     # Live      Avg. Act     Avg. !Act % Live
---------- | ---------- ------------- ------------- ------
 (  8, 64) |        545   0.100012237   0.005766640  94.56
---------- | ---------- ------------- ------------- ------
 Total Sys |        545   0.100012237   0.005766640  94.56

************************************************************************
btt output for 2.6.32:

==================== All Devices ====================

            ALL           MIN           AVG           MAX           N
--------------- ------------- ------------- ------------- -----------

Q2Q               0.000000279   0.001710581   1.803934429       69429
Q2G               0.000000908   0.001798735  23.144764798       54940
S2G               0.022460311   6.581680621  23.144763751          15
G2I               0.000000628   0.000001576   0.000120409       54942
Q2M               0.000000628   0.000001611   0.000013201       14490
I2D               0.000000768   0.289812035  86.820205789       54940
M2D               0.000005518   0.098208187   0.794441158       14490
D2C               0.000173141   0.008056256   0.219516385       69430
Q2C               0.000179077   0.259305605  86.820559403       69430

==================== Device Overhead ====================

       DEV |       Q2G       G2I       Q2M       I2D       D2C
---------- | --------- --------- --------- --------- ---------
 (  8, 64) |   0.5489%   0.0005%   0.0001%  88.4394%   3.1069%
---------- | --------- --------- --------- --------- ---------
   Overall |   0.5489%   0.0005%   0.0001%  88.4394%   3.1069%

==================== Device Merge Information ====================

       DEV |       #Q       #D   Ratio |   BLKmin   BLKavg   BLKmax    Total
---------- | -------- -------- ------- | -------- -------- -------- --------
 (  8, 64) |    69430    54955     1.3 |        8      520     2048 28614984

==================== Device Q2Q Seek Information ====================

       DEV |          NSEEKS            MEAN          MEDIAN | MODE           
---------- | --------------- --------------- --------------- | ---------------
 (  8, 64) |           69430        546377.3               0 | 0(50235)
---------- | --------------- --------------- --------------- | ---------------
   Overall |          NSEEKS            MEAN          MEDIAN | MODE           
   Average |           69430        546377.3               0 | 0(50235)

==================== Device D2D Seek Information ====================

       DEV |          NSEEKS            MEAN          MEDIAN | MODE           
---------- | --------------- --------------- --------------- | ---------------
 (  8, 64) |           54955        565286.3               0 | 0(37535)
---------- | --------------- --------------- --------------- | ---------------
   Overall |          NSEEKS            MEAN          MEDIAN | MODE           
   Average |           54955        565286.3               0 | 0(37535)

==================== Plug Information ====================

       DEV |    # Plugs # Timer Us  | % Time Q Plugged
---------- | ---------- ----------  | ----------------
 (  8, 64) |       2310(         0) |   0.049353257%

       DEV |    IOs/Unp   IOs/Unp(to)
---------- | ----------   ----------
 (  8, 64) |        7.3          0.0
---------- | ----------   ----------
   Overall |    IOs/Unp   IOs/Unp(to)
   Average |        7.3          0.0

==================== Active Requests At Q Information ====================

       DEV |  Avg Reqs @ Q
---------- | -------------
 (  8, 64) |         132.8

==================== I/O Active Period Information ====================

       DEV |     # Live      Avg. Act     Avg. !Act % Live
---------- | ---------- ------------- ------------- ------
 (  8, 64) |       4835   0.023848998   0.000714665  97.09
---------- | ---------- ------------- ------------- ------
 Total Sys |       4835   0.023848998   0.000714665  97.09



