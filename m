Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309Ab2HOMw1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 08:52:27 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48888 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754150Ab2HOMwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 08:52:25 -0400
Date: Wed, 15 Aug 2012 14:52:20 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Johannes Goetzfried 
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Tilo =?utf-8?Q?M=C3=BCller?= 
	<tilo.mueller@informatik.uni-erlangen.de>
Subject: Re: [PATCH] crypto: twofish - add x86_64/avx assembler implementation
Message-ID: <20120815125220.GB4409@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	Johannes Goetzfried <Johannes.Goetzfried@informatik.stud.uni-erlangen.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Tilo =?utf-8?Q?M=C3=BCller?= <tilo.mueller@informatik.uni-erlangen.de>
References: <20120527144919.GE17705@kronos.redsun>
 <20120815114216.209814z4mq3hxqe8@www.81.fi>
 <20120815092804.GA14676@x1.osrc.amd.com>
 <20120815140016.76673zs818g2hagw@www.81.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120815140016.76673zs818g2hagw@www.81.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, here we go. Raw data below.

On Wed, Aug 15, 2012 at 02:00:16PM +0300, Jussi Kivilinna wrote:
> >And if you tell me exactly how to run the tests and on what kernel,
> >I'll try to do so.

Ok, the box is a single-socket Bulldozer: "AMD FX(tm)-8100 Eight-Core
Processor stepping 02"; kernel is 3.6.0-rc1+ which is latest Linus +
tip/master merged ontop.

> Twofish-avx (CONFIG_TWOFISH_AVX_X86_64) is available in 3.6-rc1. For

I took CONFIG_CRYPTO_TWOFISH_AVX_X86_64 but I'm pretty sure you meant
that.

> testing you need CRYPTO_TEST build as module. You should turn off
> turbo-core, freq-scaling, etc.

$ for i in $(seq 0 7); do echo "performance" > /sys/devices/system/cpu/cpu$i/cpufreq/scaling_governor ; done
$ for i in $(seq 0 7); do echo 0 > /sys/devices/system/cpu/cpu$i/cpufreq/cpb ; done

> Testing twofish-avx ('async twofish' speed test):
>  modprobe twofish-avx-x86_64
>  modprobe tcrypt mode=504 sec=1

$ modprobe twofish-avx-x86_64
$ modprobe tcrypt mode=504 sec=1

[  224.672094] 
[  224.672094] testing speed of async ecb(twofish) encryption
[  224.681444] test 0 (128 bit key, 16 byte blocks): 4862478 operations in 1 seconds (77799648 bytes)
[  225.689190] test 1 (128 bit key, 64 byte blocks): 2040557 operations in 1 seconds (130595648 bytes)
[  226.695864] test 2 (128 bit key, 256 byte blocks): 564098 operations in 1 seconds (144409088 bytes)
[  227.702365] test 3 (128 bit key, 1024 byte blocks): 156553 operations in 1 seconds (160310272 bytes)
[  228.708960] test 4 (128 bit key, 8192 byte blocks): 20128 operations in 1 seconds (164888576 bytes)
[  229.715485] test 5 (192 bit key, 16 byte blocks): 4853879 operations in 1 seconds (77662064 bytes)
[  230.722165] test 6 (192 bit key, 64 byte blocks): 2040187 operations in 1 seconds (130571968 bytes)
[  231.729110] test 7 (192 bit key, 256 byte blocks): 564125 operations in 1 seconds (144416000 bytes)
[  232.735600] test 8 (192 bit key, 1024 byte blocks): 156231 operations in 1 seconds (159980544 bytes)
[  233.742205] test 9 (192 bit key, 8192 byte blocks): 19913 operations in 1 seconds (163127296 bytes)
[  234.748777] test 10 (256 bit key, 16 byte blocks): 4880977 operations in 1 seconds (78095632 bytes)
[  235.751405] test 11 (256 bit key, 64 byte blocks): 2045621 operations in 1 seconds (130919744 bytes)
[  236.758079] test 12 (256 bit key, 256 byte blocks): 565273 operations in 1 seconds (144709888 bytes)
[  237.764579] test 13 (256 bit key, 1024 byte blocks): 156625 operations in 1 seconds (160384000 bytes)
[  238.771175] test 14 (256 bit key, 8192 byte blocks): 20125 operations in 1 seconds (164864000 bytes)
[  239.777726] 
[  239.777726] testing speed of async ecb(twofish) decryption
[  239.787020] test 0 (128 bit key, 16 byte blocks): 4962193 operations in 1 seconds (79395088 bytes)
[  240.792405] test 1 (128 bit key, 64 byte blocks): 2056765 operations in 1 seconds (131632960 bytes)
[  241.799070] test 2 (128 bit key, 256 byte blocks): 559384 operations in 1 seconds (143202304 bytes)
[  242.805568] test 3 (128 bit key, 1024 byte blocks): 153881 operations in 1 seconds (157574144 bytes)
[  243.812191] test 4 (128 bit key, 8192 byte blocks): 19636 operations in 1 seconds (160858112 bytes)
[  244.818718] test 5 (192 bit key, 16 byte blocks): 4917689 operations in 1 seconds (78683024 bytes)
[  245.825408] test 6 (192 bit key, 64 byte blocks): 2056235 operations in 1 seconds (131599040 bytes)
[  246.832070] test 7 (192 bit key, 256 byte blocks): 560579 operations in 1 seconds (143508224 bytes)
[  247.838598] test 8 (192 bit key, 1024 byte blocks): 153813 operations in 1 seconds (157504512 bytes)
[  248.845201] test 9 (192 bit key, 8192 byte blocks): 19411 operations in 1 seconds (159014912 bytes)
[  249.851755] test 10 (256 bit key, 16 byte blocks): 4932508 operations in 1 seconds (78920128 bytes)
[  250.858372] test 11 (256 bit key, 64 byte blocks): 2057244 operations in 1 seconds (131663616 bytes)
[  251.865039] test 12 (256 bit key, 256 byte blocks): 559493 operations in 1 seconds (143230208 bytes)
[  252.871554] test 13 (256 bit key, 1024 byte blocks): 153980 operations in 1 seconds (157675520 bytes)
[  253.878159] test 14 (256 bit key, 8192 byte blocks): 19665 operations in 1 seconds (161095680 bytes)
[  254.884711] 
[  254.884711] testing speed of async cbc(twofish) encryption
[  254.898925] test 0 (128 bit key, 16 byte blocks): 5194404 operations in 1 seconds (83110464 bytes)
[  255.907087] test 1 (128 bit key, 64 byte blocks): 1916243 operations in 1 seconds (122639552 bytes)
[  256.913758] test 2 (128 bit key, 256 byte blocks): 541282 operations in 1 seconds (138568192 bytes)
[  257.916278] test 3 (128 bit key, 1024 byte blocks): 141389 operations in 1 seconds (144782336 bytes)
[  258.918865] test 4 (128 bit key, 8192 byte blocks): 17811 operations in 1 seconds (145907712 bytes)
[  259.925372] test 5 (192 bit key, 16 byte blocks): 5176387 operations in 1 seconds (82822192 bytes)
[  260.932038] test 6 (192 bit key, 64 byte blocks): 1916300 operations in 1 seconds (122643200 bytes)
[  261.938693] test 7 (192 bit key, 256 byte blocks): 542642 operations in 1 seconds (138916352 bytes)
[  262.945201] test 8 (192 bit key, 1024 byte blocks): 141318 operations in 1 seconds (144709632 bytes)
[  263.952090] test 9 (192 bit key, 8192 byte blocks): 17681 operations in 1 seconds (144842752 bytes)
[  264.958650] test 10 (256 bit key, 16 byte blocks): 5174239 operations in 1 seconds (82787824 bytes)
[  265.965289] test 11 (256 bit key, 64 byte blocks): 1909023 operations in 1 seconds (122177472 bytes)
[  266.971660] test 12 (256 bit key, 256 byte blocks): 541859 operations in 1 seconds (138715904 bytes)
[  267.978471] test 13 (256 bit key, 1024 byte blocks): 141247 operations in 1 seconds (144636928 bytes)
[  268.985066] test 14 (256 bit key, 8192 byte blocks): 17808 operations in 1 seconds (145883136 bytes)
[  269.991595] 
[  269.991595] testing speed of async cbc(twofish) decryption
[  270.001048] test 0 (128 bit key, 16 byte blocks): 4914615 operations in 1 seconds (78633840 bytes)
[  271.006285] test 1 (128 bit key, 64 byte blocks): 1986798 operations in 1 seconds (127155072 bytes)
[  272.012949] test 2 (128 bit key, 256 byte blocks): 536765 operations in 1 seconds (137411840 bytes)
[  273.019467] test 3 (128 bit key, 1024 byte blocks): 148321 operations in 1 seconds (151880704 bytes)
[  274.026071] test 4 (128 bit key, 8192 byte blocks): 18928 operations in 1 seconds (155058176 bytes)
[  275.032578] test 5 (192 bit key, 16 byte blocks): 4912929 operations in 1 seconds (78606864 bytes)
[  276.039252] test 6 (192 bit key, 64 byte blocks): 1980857 operations in 1 seconds (126774848 bytes)
[  277.045915] test 7 (192 bit key, 256 byte blocks): 533058 operations in 1 seconds (136462848 bytes)
[  278.052433] test 8 (192 bit key, 1024 byte blocks): 147262 operations in 1 seconds (150796288 bytes)
[  279.059038] test 9 (192 bit key, 8192 byte blocks): 18619 operations in 1 seconds (152526848 bytes)
[  280.065555] test 10 (256 bit key, 16 byte blocks): 4889191 operations in 1 seconds (78227056 bytes)
[  281.072228] test 11 (256 bit key, 64 byte blocks): 1981910 operations in 1 seconds (126842240 bytes)
[  282.078902] test 12 (256 bit key, 256 byte blocks): 539723 operations in 1 seconds (138169088 bytes)
[  283.081401] test 13 (256 bit key, 1024 byte blocks): 148718 operations in 1 seconds (152287232 bytes)
[  284.083999] test 14 (256 bit key, 8192 byte blocks): 18967 operations in 1 seconds (155377664 bytes)
[  285.090559] 
[  285.090559] testing speed of async ctr(twofish) encryption
[  285.104630] test 0 (128 bit key, 16 byte blocks): 4582435 operations in 1 seconds (73318960 bytes)
[  286.113221] test 1 (128 bit key, 64 byte blocks): 1948842 operations in 1 seconds (124725888 bytes)
[  287.119875] test 2 (128 bit key, 256 byte blocks): 545866 operations in 1 seconds (139741696 bytes)
[  288.126400] test 3 (128 bit key, 1024 byte blocks): 148249 operations in 1 seconds (151806976 bytes)
[  289.133004] test 4 (128 bit key, 8192 byte blocks): 18970 operations in 1 seconds (155402240 bytes)
[  290.139504] test 5 (192 bit key, 16 byte blocks): 4537518 operations in 1 seconds (72600288 bytes)
[  291.146177] test 6 (192 bit key, 64 byte blocks): 1935999 operations in 1 seconds (123903936 bytes)
[  292.152852] test 7 (192 bit key, 256 byte blocks): 537517 operations in 1 seconds (137604352 bytes)
[  293.159351] test 8 (192 bit key, 1024 byte blocks): 147055 operations in 1 seconds (150584320 bytes)
[  294.165963] test 9 (192 bit key, 8192 byte blocks): 18823 operations in 1 seconds (154198016 bytes)
[  295.172516] test 10 (256 bit key, 16 byte blocks): 4351876 operations in 1 seconds (69630016 bytes)
[  296.179154] test 11 (256 bit key, 64 byte blocks): 1957846 operations in 1 seconds (125302144 bytes)
[  297.185818] test 12 (256 bit key, 256 byte blocks): 540281 operations in 1 seconds (138311936 bytes)
[  298.192327] test 13 (256 bit key, 1024 byte blocks): 147917 operations in 1 seconds (151467008 bytes)
[  299.198913] test 14 (256 bit key, 8192 byte blocks): 19127 operations in 1 seconds (156688384 bytes)
[  300.205443] 
[  300.205443] testing speed of async ctr(twofish) decryption
[  300.214834] test 0 (128 bit key, 16 byte blocks): 4527967 operations in 1 seconds (72447472 bytes)
[  301.220136] test 1 (128 bit key, 64 byte blocks): 1949170 operations in 1 seconds (124746880 bytes)
[  302.226792] test 2 (128 bit key, 256 byte blocks): 539500 operations in 1 seconds (138112000 bytes)
[  303.233301] test 3 (128 bit key, 1024 byte blocks): 147991 operations in 1 seconds (151542784 bytes)
[  304.239914] test 4 (128 bit key, 8192 byte blocks): 18995 operations in 1 seconds (155607040 bytes)
[  305.246442] test 5 (192 bit key, 16 byte blocks): 4567525 operations in 1 seconds (73080400 bytes)
[  306.249105] test 6 (192 bit key, 64 byte blocks): 1939242 operations in 1 seconds (124111488 bytes)
[  307.251763] test 7 (192 bit key, 256 byte blocks): 537004 operations in 1 seconds (137473024 bytes)
[  308.258272] test 8 (192 bit key, 1024 byte blocks): 147203 operations in 1 seconds (150735872 bytes)
[  309.264884] test 9 (192 bit key, 8192 byte blocks): 18861 operations in 1 seconds (154509312 bytes)
[  310.271428] test 10 (256 bit key, 16 byte blocks): 4390731 operations in 1 seconds (70251696 bytes)
[  311.278075] test 11 (256 bit key, 64 byte blocks): 1961134 operations in 1 seconds (125512576 bytes)
[  312.284729] test 12 (256 bit key, 256 byte blocks): 540294 operations in 1 seconds (138315264 bytes)
[  313.291239] test 13 (256 bit key, 1024 byte blocks): 148623 operations in 1 seconds (152189952 bytes)
[  314.297834] test 14 (256 bit key, 8192 byte blocks): 19020 operations in 1 seconds (155811840 bytes)
[  315.304393] 
[  315.304393] testing speed of async lrw(twofish) encryption
[  315.318957] test 0 (256 bit key, 16 byte blocks): 3469489 operations in 1 seconds (55511824 bytes)
[  316.326743] test 1 (256 bit key, 64 byte blocks): 1608603 operations in 1 seconds (102950592 bytes)
[  317.333414] test 2 (256 bit key, 256 byte blocks): 465927 operations in 1 seconds (119277312 bytes)
[  318.339930] test 3 (256 bit key, 1024 byte blocks): 128940 operations in 1 seconds (132034560 bytes)
[  319.346534] test 4 (256 bit key, 8192 byte blocks): 16585 operations in 1 seconds (135864320 bytes)
[  320.353078] test 5 (320 bit key, 16 byte blocks): 3377257 operations in 1 seconds (54036112 bytes)
[  321.359717] test 6 (320 bit key, 64 byte blocks): 1603153 operations in 1 seconds (102601792 bytes)
[  322.366400] test 7 (320 bit key, 256 byte blocks): 458261 operations in 1 seconds (117314816 bytes)
[  323.372916] test 8 (320 bit key, 1024 byte blocks): 128620 operations in 1 seconds (131706880 bytes)
[  324.379485] test 9 (320 bit key, 8192 byte blocks): 16413 operations in 1 seconds (134455296 bytes)
[  325.386011] test 10 (384 bit key, 16 byte blocks): 3532266 operations in 1 seconds (56516256 bytes)
[  326.392692] test 11 (384 bit key, 64 byte blocks): 1589841 operations in 1 seconds (101749824 bytes)
[  327.399356] test 12 (384 bit key, 256 byte blocks): 461842 operations in 1 seconds (118231552 bytes)
[  328.405866] test 13 (384 bit key, 1024 byte blocks): 129080 operations in 1 seconds (132177920 bytes)
[  329.412472] test 14 (384 bit key, 8192 byte blocks): 16629 operations in 1 seconds (136224768 bytes)
[  330.415047] 
[  330.415047] testing speed of async lrw(twofish) decryption
[  330.415051] test 0 (256 bit key, 16 byte blocks): 3407370 operations in 1 seconds (54517920 bytes)
[  331.417671] test 1 (256 bit key, 64 byte blocks): 1616321 operations in 1 seconds (103444544 bytes)
[  332.424354] test 2 (256 bit key, 256 byte blocks): 458505 operations in 1 seconds (117377280 bytes)
[  333.430870] test 3 (256 bit key, 1024 byte blocks): 126675 operations in 1 seconds (129715200 bytes)
[  334.437790] test 4 (256 bit key, 8192 byte blocks): 16239 operations in 1 seconds (133029888 bytes)
[  335.444028] test 5 (320 bit key, 16 byte blocks): 3572964 operations in 1 seconds (57167424 bytes)
[  336.450960] test 6 (320 bit key, 64 byte blocks): 1594182 operations in 1 seconds (102027648 bytes)
[  337.457616] test 7 (320 bit key, 256 byte blocks): 459795 operations in 1 seconds (117707520 bytes)
[  338.464141] test 8 (320 bit key, 1024 byte blocks): 126568 operations in 1 seconds (129605632 bytes)
[  339.470746] test 9 (320 bit key, 8192 byte blocks): 16016 operations in 1 seconds (131203072 bytes)
[  340.477280] test 10 (384 bit key, 16 byte blocks): 3481392 operations in 1 seconds (55702272 bytes)
[  341.483944] test 11 (384 bit key, 64 byte blocks): 1611309 operations in 1 seconds (103123776 bytes)
[  342.490591] test 12 (384 bit key, 256 byte blocks): 458111 operations in 1 seconds (117276416 bytes)
[  343.497109] test 13 (384 bit key, 1024 byte blocks): 126501 operations in 1 seconds (129537024 bytes)
[  344.503696] test 14 (384 bit key, 8192 byte blocks): 16251 operations in 1 seconds (133128192 bytes)
[  345.510217] 
[  345.510217] testing speed of async xts(twofish) encryption
[  345.524414] test 0 (256 bit key, 16 byte blocks): 3107202 operations in 1 seconds (49715232 bytes)
[  346.532927] test 1 (256 bit key, 64 byte blocks): 1585412 operations in 1 seconds (101466368 bytes)
[  347.539278] test 2 (256 bit key, 256 byte blocks): 487146 operations in 1 seconds (124709376 bytes)
[  348.546099] test 3 (256 bit key, 1024 byte blocks): 137897 operations in 1 seconds (141206528 bytes)
[  349.552720] test 4 (256 bit key, 8192 byte blocks): 18001 operations in 1 seconds (147464192 bytes)
[  350.559245] test 5 (384 bit key, 16 byte blocks): 3094509 operations in 1 seconds (49512144 bytes)
[  351.565900] test 6 (384 bit key, 64 byte blocks): 1585673 operations in 1 seconds (101483072 bytes)
[  352.572557] test 7 (384 bit key, 256 byte blocks): 484334 operations in 1 seconds (123989504 bytes)
[  353.579076] test 8 (384 bit key, 1024 byte blocks): 138064 operations in 1 seconds (141377536 bytes)
[  354.581689] test 9 (384 bit key, 8192 byte blocks): 18021 operations in 1 seconds (147628032 bytes)
[  355.584216] test 10 (512 bit key, 16 byte blocks): 3166517 operations in 1 seconds (50664272 bytes)
[  356.590881] test 11 (512 bit key, 64 byte blocks): 1593724 operations in 1 seconds (101998336 bytes)
[  357.597536] test 12 (512 bit key, 256 byte blocks): 487015 operations in 1 seconds (124675840 bytes)
[  358.604045] test 13 (512 bit key, 1024 byte blocks): 138101 operations in 1 seconds (141415424 bytes)
[  359.610641] test 14 (512 bit key, 8192 byte blocks): 17990 operations in 1 seconds (147374080 bytes)
[  360.617193] 
[  360.617193] testing speed of async xts(twofish) decryption
[  360.626573] test 0 (256 bit key, 16 byte blocks): 3107491 operations in 1 seconds (49719856 bytes)
[  361.631845] test 1 (256 bit key, 64 byte blocks): 1542680 operations in 1 seconds (98731520 bytes)
[  362.638423] test 2 (256 bit key, 256 byte blocks): 481115 operations in 1 seconds (123165440 bytes)
[  363.645036] test 3 (256 bit key, 1024 byte blocks): 136886 operations in 1 seconds (140171264 bytes)
[  364.651630] test 4 (256 bit key, 8192 byte blocks): 17624 operations in 1 seconds (144375808 bytes)
[  365.658140] test 5 (384 bit key, 16 byte blocks): 3112081 operations in 1 seconds (49793296 bytes)
[  366.664511] test 6 (384 bit key, 64 byte blocks): 1544403 operations in 1 seconds (98841792 bytes)
[  367.671383] test 7 (384 bit key, 256 byte blocks): 481335 operations in 1 seconds (123221760 bytes)
[  368.677986] test 8 (384 bit key, 1024 byte blocks): 136897 operations in 1 seconds (140182528 bytes)
[  369.684600] test 9 (384 bit key, 8192 byte blocks): 17612 operations in 1 seconds (144277504 bytes)
[  370.691109] test 10 (512 bit key, 16 byte blocks): 3199446 operations in 1 seconds (51191136 bytes)
[  371.697798] test 11 (512 bit key, 64 byte blocks): 1569564 operations in 1 seconds (100452096 bytes)
[  372.704454] test 12 (512 bit key, 256 byte blocks): 482158 operations in 1 seconds (123432448 bytes)
[  373.710955] test 13 (512 bit key, 1024 byte blocks): 136846 operations in 1 seconds (140130304 bytes)
[  374.717549] test 14 (512 bit key, 8192 byte blocks): 17522 operations in 1 seconds (143540224 bytes)

> Testing twofish-x86_64-3way ('sync twofish' speed test):
>  modprobe twofish-x86_64-3way
>  modprobe tcrypt mode=202 sec=1

$ modprobe twofish-x86_64-3way
$ modprobe tcrypt mode=202 sec=1

[  841.095600] 
[  841.095600] testing speed of ecb(twofish) encryption
[  841.103893] test 0 (128 bit key, 16 byte blocks): 5059409 operations in 1 seconds (80950544 bytes)
[  842.105260] test 1 (128 bit key, 64 byte blocks): 2093363 operations in 1 seconds (133975232 bytes)
[  843.111943] test 2 (128 bit key, 256 byte blocks): 610543 operations in 1 seconds (156299008 bytes)
[  844.118754] test 3 (128 bit key, 1024 byte blocks): 161042 operations in 1 seconds (164907008 bytes)
[  845.125367] test 4 (128 bit key, 8192 byte blocks): 20397 operations in 1 seconds (167092224 bytes)
[  846.131876] test 5 (192 bit key, 16 byte blocks): 4967411 operations in 1 seconds (79478576 bytes)
[  847.138548] test 6 (192 bit key, 64 byte blocks): 2081577 operations in 1 seconds (133220928 bytes)
[  848.145213] test 7 (192 bit key, 256 byte blocks): 612129 operations in 1 seconds (156705024 bytes)
[  849.151731] test 8 (192 bit key, 1024 byte blocks): 161409 operations in 1 seconds (165282816 bytes)
[  850.158335] test 9 (192 bit key, 8192 byte blocks): 20228 operations in 1 seconds (165707776 bytes)
[  851.164844] test 10 (256 bit key, 16 byte blocks): 4968195 operations in 1 seconds (79491120 bytes)
[  852.171533] test 11 (256 bit key, 64 byte blocks): 2083566 operations in 1 seconds (133348224 bytes)
[  853.178189] test 12 (256 bit key, 256 byte blocks): 611680 operations in 1 seconds (156590080 bytes)
[  854.184697] test 13 (256 bit key, 1024 byte blocks): 161160 operations in 1 seconds (165027840 bytes)
[  855.191294] test 14 (256 bit key, 8192 byte blocks): 20400 operations in 1 seconds (167116800 bytes)
[  856.197847] 
[  856.197847] testing speed of ecb(twofish) decryption
[  856.206729] test 0 (128 bit key, 16 byte blocks): 4975693 operations in 1 seconds (79611088 bytes)
[  857.212507] test 1 (128 bit key, 64 byte blocks): 2072003 operations in 1 seconds (132608192 bytes)
[  858.219170] test 2 (128 bit key, 256 byte blocks): 611965 operations in 1 seconds (156663040 bytes)
[  859.225681] test 3 (128 bit key, 1024 byte blocks): 161027 operations in 1 seconds (164891648 bytes)
[  860.232294] test 4 (128 bit key, 8192 byte blocks): 20348 operations in 1 seconds (166690816 bytes)
[  861.238838] test 5 (192 bit key, 16 byte blocks): 4953128 operations in 1 seconds (79250048 bytes)
[  862.245476] test 6 (192 bit key, 64 byte blocks): 2070776 operations in 1 seconds (132529664 bytes)
[  863.252132] test 7 (192 bit key, 256 byte blocks): 611045 operations in 1 seconds (156427520 bytes)
[  864.258639] test 8 (192 bit key, 1024 byte blocks): 160815 operations in 1 seconds (164674560 bytes)
[  865.265271] test 9 (192 bit key, 8192 byte blocks): 20144 operations in 1 seconds (165019648 bytes)
[  866.267824] test 10 (256 bit key, 16 byte blocks): 4970527 operations in 1 seconds (79528432 bytes)
[  867.270444] test 11 (256 bit key, 64 byte blocks): 2073117 operations in 1 seconds (132679488 bytes)
[  868.277128] test 12 (256 bit key, 256 byte blocks): 612096 operations in 1 seconds (156696576 bytes)
[  869.283628] test 13 (256 bit key, 1024 byte blocks): 160923 operations in 1 seconds (164785152 bytes)
[  870.290213] test 14 (256 bit key, 8192 byte blocks): 20333 operations in 1 seconds (166567936 bytes)
[  871.296741] 
[  871.296741] testing speed of cbc(twofish) encryption
[  871.305656] test 0 (128 bit key, 16 byte blocks): 5219296 operations in 1 seconds (83508736 bytes)
[  872.311449] test 1 (128 bit key, 64 byte blocks): 1924062 operations in 1 seconds (123139968 bytes)
[  873.317800] test 2 (128 bit key, 256 byte blocks): 543826 operations in 1 seconds (139219456 bytes)
[  874.324307] test 3 (128 bit key, 1024 byte blocks): 141437 operations in 1 seconds (144831488 bytes)
[  875.330902] test 4 (128 bit key, 8192 byte blocks): 17831 operations in 1 seconds (146071552 bytes)
[  876.337439] test 5 (192 bit key, 16 byte blocks): 5208718 operations in 1 seconds (83339488 bytes)
[  877.344101] test 6 (192 bit key, 64 byte blocks): 1920005 operations in 1 seconds (122880320 bytes)
[  878.350767] test 7 (192 bit key, 256 byte blocks): 543963 operations in 1 seconds (139254528 bytes)
[  879.357265] test 8 (192 bit key, 1024 byte blocks): 141507 operations in 1 seconds (144903168 bytes)
[  880.363889] test 9 (192 bit key, 8192 byte blocks): 17685 operations in 1 seconds (144875520 bytes)
[  881.370413] test 10 (256 bit key, 16 byte blocks): 5186062 operations in 1 seconds (82976992 bytes)
[  882.377078] test 11 (256 bit key, 64 byte blocks): 1909259 operations in 1 seconds (122192576 bytes)
[  883.383725] test 12 (256 bit key, 256 byte blocks): 543371 operations in 1 seconds (139102976 bytes)
[  884.390250] test 13 (256 bit key, 1024 byte blocks): 141395 operations in 1 seconds (144788480 bytes)
[  885.396838] test 14 (256 bit key, 8192 byte blocks): 17823 operations in 1 seconds (146006016 bytes)
[  886.403391] 
[  886.403391] testing speed of cbc(twofish) decryption
[  886.411632] test 0 (128 bit key, 16 byte blocks): 5012934 operations in 1 seconds (80206944 bytes)
[  887.418033] test 1 (128 bit key, 64 byte blocks): 2025951 operations in 1 seconds (129660864 bytes)
[  888.424706] test 2 (128 bit key, 256 byte blocks): 596675 operations in 1 seconds (152748800 bytes)
[  889.431233] test 3 (128 bit key, 1024 byte blocks): 156569 operations in 1 seconds (160326656 bytes)
[  890.433868] test 4 (128 bit key, 8192 byte blocks): 19783 operations in 1 seconds (162062336 bytes)
[  891.436382] test 5 (192 bit key, 16 byte blocks): 4999583 operations in 1 seconds (79993328 bytes)
[  892.443032] test 6 (192 bit key, 64 byte blocks): 2025099 operations in 1 seconds (129606336 bytes)
[  893.449696] test 7 (192 bit key, 256 byte blocks): 593294 operations in 1 seconds (151883264 bytes)
[  894.456204] test 8 (192 bit key, 1024 byte blocks): 156223 operations in 1 seconds (159972352 bytes)
[  895.462798] test 9 (192 bit key, 8192 byte blocks): 19560 operations in 1 seconds (160235520 bytes)
[  896.469351] test 10 (256 bit key, 16 byte blocks): 5002391 operations in 1 seconds (80038256 bytes)
[  897.475997] test 11 (256 bit key, 64 byte blocks): 2021338 operations in 1 seconds (129365632 bytes)
[  898.482681] test 12 (256 bit key, 256 byte blocks): 597158 operations in 1 seconds (152872448 bytes)
[  899.489171] test 13 (256 bit key, 1024 byte blocks): 156466 operations in 1 seconds (160221184 bytes)
[  900.495775] test 14 (256 bit key, 8192 byte blocks): 19748 operations in 1 seconds (161775616 bytes)
[  901.502295] 
[  901.502295] testing speed of ctr(twofish) encryption
[  901.510534] test 0 (128 bit key, 16 byte blocks): 4775185 operations in 1 seconds (76402960 bytes)
[  902.516972] test 1 (128 bit key, 64 byte blocks): 1969757 operations in 1 seconds (126064448 bytes)
[  903.523636] test 2 (128 bit key, 256 byte blocks): 596735 operations in 1 seconds (152764160 bytes)
[  904.530162] test 3 (128 bit key, 1024 byte blocks): 157023 operations in 1 seconds (160791552 bytes)
[  905.536756] test 4 (128 bit key, 8192 byte blocks): 19844 operations in 1 seconds (162562048 bytes)
[  906.543299] test 5 (192 bit key, 16 byte blocks): 4802348 operations in 1 seconds (76837568 bytes)
[  907.549938] test 6 (192 bit key, 64 byte blocks): 1977219 operations in 1 seconds (126542016 bytes)
[  908.556613] test 7 (192 bit key, 256 byte blocks): 595537 operations in 1 seconds (152457472 bytes)
[  909.563121] test 8 (192 bit key, 1024 byte blocks): 156491 operations in 1 seconds (160246784 bytes)
[  910.569725] test 9 (192 bit key, 8192 byte blocks): 19541 operations in 1 seconds (160079872 bytes)
[  911.576270] test 10 (256 bit key, 16 byte blocks): 4860804 operations in 1 seconds (77772864 bytes)
[  912.582924] test 11 (256 bit key, 64 byte blocks): 1980010 operations in 1 seconds (126720640 bytes)
[  913.589589] test 12 (256 bit key, 256 byte blocks): 597238 operations in 1 seconds (152892928 bytes)
[  914.596105] test 13 (256 bit key, 1024 byte blocks): 157162 operations in 1 seconds (160933888 bytes)
[  915.598703] test 14 (256 bit key, 8192 byte blocks): 19832 operations in 1 seconds (162463744 bytes)
[  916.601249] 
[  916.601249] testing speed of ctr(twofish) decryption
[  916.609490] test 0 (128 bit key, 16 byte blocks): 4601859 operations in 1 seconds (73629744 bytes)
[  917.615919] test 1 (128 bit key, 64 byte blocks): 1970487 operations in 1 seconds (126111168 bytes)
[  918.622573] test 2 (128 bit key, 256 byte blocks): 587668 operations in 1 seconds (150443008 bytes)
[  919.629092] test 3 (128 bit key, 1024 byte blocks): 157030 operations in 1 seconds (160798720 bytes)
[  920.635695] test 4 (128 bit key, 8192 byte blocks): 19868 operations in 1 seconds (162758656 bytes)
[  921.642194] test 5 (192 bit key, 16 byte blocks): 4837646 operations in 1 seconds (77402336 bytes)
[  922.648877] test 6 (192 bit key, 64 byte blocks): 1978413 operations in 1 seconds (126618432 bytes)
[  923.655549] test 7 (192 bit key, 256 byte blocks): 590723 operations in 1 seconds (151225088 bytes)
[  924.662059] test 8 (192 bit key, 1024 byte blocks): 156488 operations in 1 seconds (160243712 bytes)
[  925.668663] test 9 (192 bit key, 8192 byte blocks): 19533 operations in 1 seconds (160014336 bytes)
[  926.675208] test 10 (256 bit key, 16 byte blocks): 4877702 operations in 1 seconds (78043232 bytes)
[  927.681854] test 11 (256 bit key, 64 byte blocks): 1981581 operations in 1 seconds (126821184 bytes)
[  928.688517] test 12 (256 bit key, 256 byte blocks): 591865 operations in 1 seconds (151517440 bytes)
[  929.695027] test 13 (256 bit key, 1024 byte blocks): 157106 operations in 1 seconds (160876544 bytes)
[  930.701622] test 14 (256 bit key, 8192 byte blocks): 19818 operations in 1 seconds (162349056 bytes)
[  931.708148] 
[  931.708148] testing speed of lrw(twofish) encryption
[  931.716391] test 0 (256 bit key, 16 byte blocks): 3742901 operations in 1 seconds (59886416 bytes)
[  932.723129] test 1 (256 bit key, 64 byte blocks): 1632818 operations in 1 seconds (104500352 bytes)
[  933.729812] test 2 (256 bit key, 256 byte blocks): 507407 operations in 1 seconds (129896192 bytes)
[  934.736320] test 3 (256 bit key, 1024 byte blocks): 134953 operations in 1 seconds (138191872 bytes)
[  935.742933] test 4 (256 bit key, 8192 byte blocks): 17152 operations in 1 seconds (140509184 bytes)
[  936.749449] test 5 (320 bit key, 16 byte blocks): 3604847 operations in 1 seconds (57677552 bytes)
[  937.756114] test 6 (320 bit key, 64 byte blocks): 1645280 operations in 1 seconds (105297920 bytes)
[  938.762787] test 7 (320 bit key, 256 byte blocks): 505243 operations in 1 seconds (129342208 bytes)
[  939.765318] test 8 (320 bit key, 1024 byte blocks): 135382 operations in 1 seconds (138631168 bytes)
[  940.767912] test 9 (320 bit key, 8192 byte blocks): 17004 operations in 1 seconds (139296768 bytes)
[  941.774421] test 10 (384 bit key, 16 byte blocks): 3748381 operations in 1 seconds (59974096 bytes)
[  942.781104] test 11 (384 bit key, 64 byte blocks): 1618390 operations in 1 seconds (103576960 bytes)
[  943.787759] test 12 (384 bit key, 256 byte blocks): 508853 operations in 1 seconds (130266368 bytes)
[  944.793973] test 13 (384 bit key, 1024 byte blocks): 135082 operations in 1 seconds (138323968 bytes)
[  945.800560] test 14 (384 bit key, 8192 byte blocks): 17158 operations in 1 seconds (140558336 bytes)
[  946.807124] 
[  946.807124] testing speed of lrw(twofish) decryption
[  946.815364] test 0 (256 bit key, 16 byte blocks): 3601916 operations in 1 seconds (57630656 bytes)
[  947.821765] test 1 (256 bit key, 64 byte blocks): 1661901 operations in 1 seconds (106361664 bytes)
[  948.828439] test 2 (256 bit key, 256 byte blocks): 503586 operations in 1 seconds (128918016 bytes)
[  949.834947] test 3 (256 bit key, 1024 byte blocks): 134739 operations in 1 seconds (137972736 bytes)
[  950.841551] test 4 (256 bit key, 8192 byte blocks): 17087 operations in 1 seconds (139976704 bytes)
[  951.848113] test 5 (320 bit key, 16 byte blocks): 3718723 operations in 1 seconds (59499568 bytes)
[  952.854741] test 6 (320 bit key, 64 byte blocks): 1640905 operations in 1 seconds (105017920 bytes)
[  953.861405] test 7 (320 bit key, 256 byte blocks): 505306 operations in 1 seconds (129358336 bytes)
[  954.867924] test 8 (320 bit key, 1024 byte blocks): 134609 operations in 1 seconds (137839616 bytes)
[  955.874527] test 9 (320 bit key, 8192 byte blocks): 16971 operations in 1 seconds (139026432 bytes)
[  956.881088] test 10 (384 bit key, 16 byte blocks): 3591435 operations in 1 seconds (57462960 bytes)
[  957.887717] test 11 (384 bit key, 64 byte blocks): 1649581 operations in 1 seconds (105573184 bytes)
[  958.894382] test 12 (384 bit key, 256 byte blocks): 502560 operations in 1 seconds (128655360 bytes)
[  959.900892] test 13 (384 bit key, 1024 byte blocks): 134723 operations in 1 seconds (137956352 bytes)
[  960.907488] test 14 (384 bit key, 8192 byte blocks): 17095 operations in 1 seconds (140042240 bytes)
[  961.914039] 
[  961.914039] testing speed of xts(twofish) encryption
[  961.922282] test 0 (256 bit key, 16 byte blocks): 3145313 operations in 1 seconds (50325008 bytes)
[  962.928692] test 1 (256 bit key, 64 byte blocks): 1583838 operations in 1 seconds (101365632 bytes)
[  963.931688] test 2 (256 bit key, 256 byte blocks): 522571 operations in 1 seconds (133778176 bytes)
[  964.934178] test 3 (256 bit key, 1024 byte blocks): 142343 operations in 1 seconds (145759232 bytes)
[  965.940803] test 4 (256 bit key, 8192 byte blocks): 18213 operations in 1 seconds (149200896 bytes)
[  966.947327] test 5 (384 bit key, 16 byte blocks): 3152410 operations in 1 seconds (50438560 bytes)
[  967.953973] test 6 (384 bit key, 64 byte blocks): 1583572 operations in 1 seconds (101348608 bytes)
[  968.960638] test 7 (384 bit key, 256 byte blocks): 523459 operations in 1 seconds (134005504 bytes)
[  969.967147] test 8 (384 bit key, 1024 byte blocks): 142362 operations in 1 seconds (145778688 bytes)
[  970.973760] test 9 (384 bit key, 8192 byte blocks): 18217 operations in 1 seconds (149233664 bytes)
[  971.980303] test 10 (512 bit key, 16 byte blocks): 3303261 operations in 1 seconds (52852176 bytes)
[  972.986948] test 11 (512 bit key, 64 byte blocks): 1626050 operations in 1 seconds (104067200 bytes)
[  973.993616] test 12 (512 bit key, 256 byte blocks): 526250 operations in 1 seconds (134720000 bytes)
[  975.000114] test 13 (512 bit key, 1024 byte blocks): 142627 operations in 1 seconds (146050048 bytes)
[  976.006710] test 14 (512 bit key, 8192 byte blocks): 18277 operations in 1 seconds (149725184 bytes)
[  977.013263] 
[  977.013263] testing speed of xts(twofish) decryption
[  977.022105] test 0 (256 bit key, 16 byte blocks): 3135829 operations in 1 seconds (50173264 bytes)
[  978.027922] test 1 (256 bit key, 64 byte blocks): 1578849 operations in 1 seconds (101046336 bytes)
[  979.034578] test 2 (256 bit key, 256 byte blocks): 521004 operations in 1 seconds (133377024 bytes)
[  980.041098] test 3 (256 bit key, 1024 byte blocks): 141705 operations in 1 seconds (145105920 bytes)
[  981.047709] test 4 (256 bit key, 8192 byte blocks): 18161 operations in 1 seconds (148774912 bytes)
[  982.054227] test 5 (384 bit key, 16 byte blocks): 3138227 operations in 1 seconds (50211632 bytes)
[  983.060883] test 6 (384 bit key, 64 byte blocks): 1578454 operations in 1 seconds (101021056 bytes)
[  984.067555] test 7 (384 bit key, 256 byte blocks): 520945 operations in 1 seconds (133361920 bytes)
[  985.074064] test 8 (384 bit key, 1024 byte blocks): 141746 operations in 1 seconds (145147904 bytes)
[  986.080676] test 9 (384 bit key, 8192 byte blocks): 18170 operations in 1 seconds (148848640 bytes)
[  987.087194] test 10 (512 bit key, 16 byte blocks): 3303084 operations in 1 seconds (52849344 bytes)
[  988.093869] test 11 (512 bit key, 64 byte blocks): 1623781 operations in 1 seconds (103921984 bytes)
[  989.096562] test 12 (512 bit key, 256 byte blocks): 526076 operations in 1 seconds (134675456 bytes)
[  990.099044] test 13 (512 bit key, 1024 byte blocks): 142068 operations in 1 seconds (145477632 bytes)
[  991.105639] test 14 (512 bit key, 8192 byte blocks): 18138 operations in 1 seconds (148586496 bytes)

Let me know if you need more tests.

HTH.

-- 
Regards/Gruss,
Boris.
