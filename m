Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab2HOPdN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 11:33:13 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37064 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754210Ab2HOPdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 11:33:10 -0400
Date: Wed, 15 Aug 2012 17:33:05 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Johannes Goetzfried 
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Tilo =?utf-8?Q?M=C3=BCller?= 
	<tilo.mueller@informatik.uni-erlangen.de>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: Re: [PATCH] crypto: twofish - add x86_64/avx assembler implementation
Message-ID: <20120815153303.GC4103@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	Johannes Goetzfried <Johannes.Goetzfried@informatik.stud.uni-erlangen.de>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Tilo =?utf-8?Q?M=C3=BCller?= <tilo.mueller@informatik.uni-erlangen.de>,
	Herbert Xu <herbert@gondor.apana.org.au>
References: <20120815140331.GB4103@x1.osrc.amd.com>
 <20120815141927.7893.87619.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120815141927.7893.87619.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 05:22:03PM +0300, Jussi Kivilinna wrote:

> Patch replaces 'movb' instructions with 'movzbl' to break false
> register dependencies and interleaves instructions better for
> out-of-order scheduling.
>
> Also move common round code to separate function to reduce object
> size.

Ok, redid the first test

$ modprobe twofish-avx-x86_64
$ modprobe tcrypt mode=504 sec=1

and from quickly juxtaposing the two results, I'd say the patch makes
things slightly worse but you'd need to run your scripts on it to get
the accurate results:

[   98.206067] testing speed of async ecb(twofish) encryption
[   98.214796] test 0 (128 bit key, 16 byte blocks): 4549296 operations in 1 seconds (72788736 bytes)
[   99.221569] test 1 (128 bit key, 64 byte blocks): 1995934 operations in 1 seconds (127739776 bytes)
[  100.228250] test 2 (128 bit key, 256 byte blocks): 535040 operations in 1 seconds (136970240 bytes)
[  101.234751] test 3 (128 bit key, 1024 byte blocks): 148602 operations in 1 seconds (152168448 bytes)
[  102.241345] test 4 (128 bit key, 8192 byte blocks): 19148 operations in 1 seconds (156860416 bytes)
[  103.247880] test 5 (192 bit key, 16 byte blocks): 4558391 operations in 1 seconds (72934256 bytes)
[  104.254547] test 6 (192 bit key, 64 byte blocks): 1997838 operations in 1 seconds (127861632 bytes)
[  105.261202] test 7 (192 bit key, 256 byte blocks): 534396 operations in 1 seconds (136805376 bytes)
[  106.267694] test 8 (192 bit key, 1024 byte blocks): 148199 operations in 1 seconds (151755776 bytes)
[  107.274296] test 9 (192 bit key, 8192 byte blocks): 18913 operations in 1 seconds (154935296 bytes)
[  108.280824] test 10 (256 bit key, 16 byte blocks): 4595524 operations in 1 seconds (73528384 bytes)
[  109.287496] test 11 (256 bit key, 64 byte blocks): 1997893 operations in 1 seconds (127865152 bytes)
[  110.294168] test 12 (256 bit key, 256 byte blocks): 533790 operations in 1 seconds (136650240 bytes)
[  111.300679] test 13 (256 bit key, 1024 byte blocks): 148787 operations in 1 seconds (152357888 bytes)
[  112.303561] test 14 (256 bit key, 8192 byte blocks): 19146 operations in 1 seconds (156844032 bytes)
[  113.310104] 
[  113.310104] testing speed of async ecb(twofish) decryption
[  113.319419] test 0 (128 bit key, 16 byte blocks): 4754043 operations in 1 seconds (76064688 bytes)
[  114.324768] test 1 (128 bit key, 64 byte blocks): 1831420 operations in 1 seconds (117210880 bytes)
[  115.331441] test 2 (128 bit key, 256 byte blocks): 541170 operations in 1 seconds (138539520 bytes)
[  116.337957] test 3 (128 bit key, 1024 byte blocks): 150538 operations in 1 seconds (154150912 bytes)
[  117.344571] test 4 (128 bit key, 8192 byte blocks): 19397 operations in 1 seconds (158900224 bytes)
[  118.351122] test 5 (192 bit key, 16 byte blocks): 4753957 operations in 1 seconds (76063312 bytes)
[  119.357778] test 6 (192 bit key, 64 byte blocks): 1828676 operations in 1 seconds (117035264 bytes)
[  120.364459] test 7 (192 bit key, 256 byte blocks): 540331 operations in 1 seconds (138324736 bytes)
[  121.370969] test 8 (192 bit key, 1024 byte blocks): 150348 operations in 1 seconds (153956352 bytes)
[  122.377573] test 9 (192 bit key, 8192 byte blocks): 19196 operations in 1 seconds (157253632 bytes)
[  123.384080] test 10 (256 bit key, 16 byte blocks): 4664399 operations in 1 seconds (74630384 bytes)
[  124.390782] test 11 (256 bit key, 64 byte blocks): 1839324 operations in 1 seconds (117716736 bytes)
[  125.397463] test 12 (256 bit key, 256 byte blocks): 538735 operations in 1 seconds (137916160 bytes)
[  126.403962] test 13 (256 bit key, 1024 byte blocks): 150489 operations in 1 seconds (154100736 bytes)
[  127.410567] test 14 (256 bit key, 8192 byte blocks): 19397 operations in 1 seconds (158900224 bytes)
[  128.417091] 
[  128.417091] testing speed of async cbc(twofish) encryption
[  128.431227] test 0 (128 bit key, 16 byte blocks): 4681239 operations in 1 seconds (74899824 bytes)
[  129.439466] test 1 (128 bit key, 64 byte blocks): 1836636 operations in 1 seconds (117544704 bytes)
[  130.446131] test 2 (128 bit key, 256 byte blocks): 536055 operations in 1 seconds (137230080 bytes)
[  131.452631] test 3 (128 bit key, 1024 byte blocks): 140955 operations in 1 seconds (144337920 bytes)
[  132.459243] test 4 (128 bit key, 8192 byte blocks): 17821 operations in 1 seconds (145989632 bytes)
[  133.466124] test 5 (192 bit key, 16 byte blocks): 4674373 operations in 1 seconds (74789968 bytes)
[  134.472728] test 6 (192 bit key, 64 byte blocks): 1835821 operations in 1 seconds (117492544 bytes)
[  135.479374] test 7 (192 bit key, 256 byte blocks): 535882 operations in 1 seconds (137185792 bytes)
[  136.485876] test 8 (192 bit key, 1024 byte blocks): 140917 operations in 1 seconds (144299008 bytes)
[  137.492470] test 9 (192 bit key, 8192 byte blocks): 17707 operations in 1 seconds (145055744 bytes)
[  138.498979] test 10 (256 bit key, 16 byte blocks): 4674648 operations in 1 seconds (74794368 bytes)
[  139.505660] test 11 (256 bit key, 64 byte blocks): 1828219 operations in 1 seconds (117006016 bytes)
[  140.512343] test 12 (256 bit key, 256 byte blocks): 535835 operations in 1 seconds (137173760 bytes)
[  141.518842] test 13 (256 bit key, 1024 byte blocks): 140884 operations in 1 seconds (144265216 bytes)
[  142.525447] test 14 (256 bit key, 8192 byte blocks): 17815 operations in 1 seconds (145940480 bytes)
[  143.531972] 
[  143.531972] testing speed of async cbc(twofish) decryption
[  143.541345] test 0 (128 bit key, 16 byte blocks): 4461471 operations in 1 seconds (71383536 bytes)
[  144.546671] test 1 (128 bit key, 64 byte blocks): 1726158 operations in 1 seconds (110474112 bytes)
[  145.553334] test 2 (128 bit key, 256 byte blocks): 524618 operations in 1 seconds (134302208 bytes)
[  146.559862] test 3 (128 bit key, 1024 byte blocks): 145305 operations in 1 seconds (148792320 bytes)
[  147.566457] test 4 (128 bit key, 8192 byte blocks): 18667 operations in 1 seconds (152920064 bytes)
[  148.572965] test 5 (192 bit key, 16 byte blocks): 4458941 operations in 1 seconds (71343056 bytes)
[  149.579638] test 6 (192 bit key, 64 byte blocks): 1734677 operations in 1 seconds (111019328 bytes)
[  150.586303] test 7 (192 bit key, 256 byte blocks): 521797 operations in 1 seconds (133580032 bytes)
[  151.592811] test 8 (192 bit key, 1024 byte blocks): 144554 operations in 1 seconds (148023296 bytes)
[  152.599423] test 9 (192 bit key, 8192 byte blocks): 18461 operations in 1 seconds (151232512 bytes)
[  153.605932] test 10 (256 bit key, 16 byte blocks): 4454216 operations in 1 seconds (71267456 bytes)
[  154.612614] test 11 (256 bit key, 64 byte blocks): 1749350 operations in 1 seconds (111958400 bytes)
[  155.619270] test 12 (256 bit key, 256 byte blocks): 525143 operations in 1 seconds (134436608 bytes)
[  156.625778] test 13 (256 bit key, 1024 byte blocks): 145597 operations in 1 seconds (149091328 bytes)
[  157.632367] test 14 (256 bit key, 8192 byte blocks): 18667 operations in 1 seconds (152920064 bytes)
[  158.638911] 
[  158.638911] testing speed of async ctr(twofish) encryption
[  158.652915] test 0 (128 bit key, 16 byte blocks): 4582013 operations in 1 seconds (73312208 bytes)
[  159.661274] test 1 (128 bit key, 64 byte blocks): 1949294 operations in 1 seconds (124754816 bytes)
[  160.667949] test 2 (128 bit key, 256 byte blocks): 519205 operations in 1 seconds (132916480 bytes)
[  161.674749] test 3 (128 bit key, 1024 byte blocks): 142060 operations in 1 seconds (145469440 bytes)
[  162.681372] test 4 (128 bit key, 8192 byte blocks): 18272 operations in 1 seconds (149684224 bytes)
[  163.687577] test 5 (192 bit key, 16 byte blocks): 4539161 operations in 1 seconds (72626576 bytes)
[  164.694561] test 6 (192 bit key, 64 byte blocks): 1935006 operations in 1 seconds (123840384 bytes)
[  165.701209] test 7 (192 bit key, 256 byte blocks): 517208 operations in 1 seconds (132405248 bytes)
[  166.707725] test 8 (192 bit key, 1024 byte blocks): 141790 operations in 1 seconds (145192960 bytes)
[  167.714338] test 9 (192 bit key, 8192 byte blocks): 18120 operations in 1 seconds (148439040 bytes)
[  168.720856] test 10 (256 bit key, 16 byte blocks): 4379275 operations in 1 seconds (70068400 bytes)
[  169.727530] test 11 (256 bit key, 64 byte blocks): 1957465 operations in 1 seconds (125277760 bytes)
[  170.734185] test 12 (256 bit key, 256 byte blocks): 519760 operations in 1 seconds (133058560 bytes)
[  171.740392] test 13 (256 bit key, 1024 byte blocks): 142374 operations in 1 seconds (145790976 bytes)
[  172.746986] test 14 (256 bit key, 8192 byte blocks): 18292 operations in 1 seconds (149848064 bytes)
[  173.753539] 
[  173.753539] testing speed of async ctr(twofish) decryption
[  173.762929] test 0 (128 bit key, 16 byte blocks): 4465609 operations in 1 seconds (71449744 bytes)
[  174.768467] test 1 (128 bit key, 64 byte blocks): 1947565 operations in 1 seconds (124644160 bytes)
[  175.775139] test 2 (128 bit key, 256 byte blocks): 523259 operations in 1 seconds (133954304 bytes)
[  176.781352] test 3 (128 bit key, 1024 byte blocks): 141135 operations in 1 seconds (144522240 bytes)
[  177.787959] test 4 (128 bit key, 8192 byte blocks): 17984 operations in 1 seconds (147324928 bytes)
[  178.794512] test 5 (192 bit key, 16 byte blocks): 4541736 operations in 1 seconds (72667776 bytes)
[  179.801141] test 6 (192 bit key, 64 byte blocks): 1937279 operations in 1 seconds (123985856 bytes)
[  180.807805] test 7 (192 bit key, 256 byte blocks): 513856 operations in 1 seconds (131547136 bytes)
[  181.814331] test 8 (192 bit key, 1024 byte blocks): 141039 operations in 1 seconds (144423936 bytes)
[  182.820918] test 9 (192 bit key, 8192 byte blocks): 17825 operations in 1 seconds (146022400 bytes)
[  183.827461] test 10 (256 bit key, 16 byte blocks): 4380875 operations in 1 seconds (70094000 bytes)
[  184.834419] test 11 (256 bit key, 64 byte blocks): 1959937 operations in 1 seconds (125435968 bytes)
[  185.841075] test 12 (256 bit key, 256 byte blocks): 515782 operations in 1 seconds (132040192 bytes)
[  186.847585] test 13 (256 bit key, 1024 byte blocks): 142571 operations in 1 seconds (145992704 bytes)
[  187.854181] test 14 (256 bit key, 8192 byte blocks): 18105 operations in 1 seconds (148316160 bytes)
[  188.860717] 
[  188.860717] testing speed of async lrw(twofish) encryption
[  188.875294] test 0 (256 bit key, 16 byte blocks): 3445285 operations in 1 seconds (55124560 bytes)
[  189.883381] test 1 (256 bit key, 64 byte blocks): 1585896 operations in 1 seconds (101497344 bytes)
[  190.890072] test 2 (256 bit key, 256 byte blocks): 449477 operations in 1 seconds (115066112 bytes)
[  191.896590] test 3 (256 bit key, 1024 byte blocks): 123541 operations in 1 seconds (126505984 bytes)
[  192.903174] test 4 (256 bit key, 8192 byte blocks): 15868 operations in 1 seconds (129990656 bytes)
[  193.909694] test 5 (320 bit key, 16 byte blocks): 3590396 operations in 1 seconds (57446336 bytes)
[  194.916355] test 6 (320 bit key, 64 byte blocks): 1579004 operations in 1 seconds (101056256 bytes)
[  195.923041] test 7 (320 bit key, 256 byte blocks): 449033 operations in 1 seconds (114952448 bytes)
[  196.929529] test 8 (320 bit key, 1024 byte blocks): 123347 operations in 1 seconds (126307328 bytes)
[  197.936142] test 9 (320 bit key, 8192 byte blocks): 15762 operations in 1 seconds (129122304 bytes)
[  198.942702] test 10 (384 bit key, 16 byte blocks): 3496049 operations in 1 seconds (55936784 bytes)
[  199.949333] test 11 (384 bit key, 64 byte blocks): 1589166 operations in 1 seconds (101706624 bytes)
[  200.955996] test 12 (384 bit key, 256 byte blocks): 449480 operations in 1 seconds (115066880 bytes)
[  201.962497] test 13 (384 bit key, 1024 byte blocks): 123767 operations in 1 seconds (126737408 bytes)
[  202.969101] test 14 (384 bit key, 8192 byte blocks): 15921 operations in 1 seconds (130424832 bytes)
[  203.971665] 
[  203.971665] testing speed of async lrw(twofish) decryption
[  203.971755] test 0 (256 bit key, 16 byte blocks): 3558879 operations in 1 seconds (56942064 bytes)
[  204.974331] test 1 (256 bit key, 64 byte blocks): 1588116 operations in 1 seconds (101639424 bytes)
[  205.981001] test 2 (256 bit key, 256 byte blocks): 451198 operations in 1 seconds (115506688 bytes)
[  206.987510] test 3 (256 bit key, 1024 byte blocks): 124791 operations in 1 seconds (127785984 bytes)
[  207.994115] test 4 (256 bit key, 8192 byte blocks): 16087 operations in 1 seconds (131784704 bytes)
[  209.000650] test 5 (320 bit key, 16 byte blocks): 3559066 operations in 1 seconds (56945056 bytes)
[  210.007298] test 6 (320 bit key, 64 byte blocks): 1579234 operations in 1 seconds (101070976 bytes)
[  211.013960] test 7 (320 bit key, 256 byte blocks): 454953 operations in 1 seconds (116467968 bytes)
[  212.020469] test 8 (320 bit key, 1024 byte blocks): 124810 operations in 1 seconds (127805440 bytes)
[  213.027082] test 9 (320 bit key, 8192 byte blocks): 15887 operations in 1 seconds (130146304 bytes)
[  214.033610] test 10 (384 bit key, 16 byte blocks): 3554484 operations in 1 seconds (56871744 bytes)
[  215.040272] test 11 (384 bit key, 64 byte blocks): 1583334 operations in 1 seconds (101333376 bytes)
[  216.046937] test 12 (384 bit key, 256 byte blocks): 453554 operations in 1 seconds (116109824 bytes)
[  217.053436] test 13 (384 bit key, 1024 byte blocks): 124894 operations in 1 seconds (127891456 bytes)
[  218.060032] test 14 (384 bit key, 8192 byte blocks): 16080 operations in 1 seconds (131727360 bytes)
[  219.066597] 
[  219.066597] testing speed of async xts(twofish) encryption
[  219.080737] test 0 (256 bit key, 16 byte blocks): 3105784 operations in 1 seconds (49692544 bytes)
[  220.089254] test 1 (256 bit key, 64 byte blocks): 1586587 operations in 1 seconds (101541568 bytes)
[  221.095918] test 2 (256 bit key, 256 byte blocks): 475166 operations in 1 seconds (121642496 bytes)
[  222.102427] test 3 (256 bit key, 1024 byte blocks): 133144 operations in 1 seconds (136339456 bytes)
[  223.109038] test 4 (256 bit key, 8192 byte blocks): 17219 operations in 1 seconds (141058048 bytes)
[  224.115549] test 5 (384 bit key, 16 byte blocks): 3097574 operations in 1 seconds (49561184 bytes)
[  225.122213] test 6 (384 bit key, 64 byte blocks): 1585836 operations in 1 seconds (101493504 bytes)
[  226.128885] test 7 (384 bit key, 256 byte blocks): 475173 operations in 1 seconds (121644288 bytes)
[  227.135398] test 8 (384 bit key, 1024 byte blocks): 133173 operations in 1 seconds (136369152 bytes)
[  228.138011] test 9 (384 bit key, 8192 byte blocks): 17254 operations in 1 seconds (141344768 bytes)
[  229.140563] test 10 (512 bit key, 16 byte blocks): 3171090 operations in 1 seconds (50737440 bytes)
[  230.147211] test 11 (512 bit key, 64 byte blocks): 1595445 operations in 1 seconds (102108480 bytes)
[  231.153866] test 12 (512 bit key, 256 byte blocks): 475161 operations in 1 seconds (121641216 bytes)
[  232.160384] test 13 (512 bit key, 1024 byte blocks): 133269 operations in 1 seconds (136467456 bytes)
[  233.166970] test 14 (512 bit key, 8192 byte blocks): 17225 operations in 1 seconds (141107200 bytes)
[  234.173501] 
[  234.173501] testing speed of async xts(twofish) decryption
[  234.182898] test 0 (256 bit key, 16 byte blocks): 3095689 operations in 1 seconds (49531024 bytes)
[  235.188173] test 1 (256 bit key, 64 byte blocks): 1433025 operations in 1 seconds (91713600 bytes)
[  236.194753] test 2 (256 bit key, 256 byte blocks): 472038 operations in 1 seconds (120841728 bytes)
[  237.201347] test 3 (256 bit key, 1024 byte blocks): 134015 operations in 1 seconds (137231360 bytes)
[  238.207969] test 4 (256 bit key, 8192 byte blocks): 17446 operations in 1 seconds (142917632 bytes)
[  239.214478] test 5 (384 bit key, 16 byte blocks): 3099755 operations in 1 seconds (49596080 bytes)
[  240.221142] test 6 (384 bit key, 64 byte blocks): 1432335 operations in 1 seconds (91669440 bytes)
[  241.227711] test 7 (384 bit key, 256 byte blocks): 470340 operations in 1 seconds (120407040 bytes)
[  242.234314] test 8 (384 bit key, 1024 byte blocks): 133929 operations in 1 seconds (137143296 bytes)
[  243.240926] test 9 (384 bit key, 8192 byte blocks): 17442 operations in 1 seconds (142884864 bytes)
[  244.247453] test 10 (512 bit key, 16 byte blocks): 3193773 operations in 1 seconds (51100368 bytes)
[  245.254119] test 11 (512 bit key, 64 byte blocks): 1440631 operations in 1 seconds (92200384 bytes)
[  246.260689] test 12 (512 bit key, 256 byte blocks): 475293 operations in 1 seconds (121675008 bytes)
[  247.267283] test 13 (512 bit key, 1024 byte blocks): 134350 operations in 1 seconds (137574400 bytes)
[  248.273879] test 14 (512 bit key, 8192 byte blocks): 17441 operations in 1 seconds (142876672 bytes)

-- 
Regards/Gruss,
Boris.
