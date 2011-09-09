Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759066Ab1IINns (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 09:43:48 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:46591 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758807Ab1IINnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 09:43:47 -0400
X-SpamScore: -7
X-BigFish: VPS-7(zzc85fh146fK1432N98dKzz1202h1082kzz8275eha1495iz32i668h839h34h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LR9CQT-02-18C-02
X-M-MSG: 
Date: Fri, 9 Sep 2011 15:42:33 +0200
From: Borislav Petkov <bp@alien8.de>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
        Ingo Molnar <mingo@elte.hu>, melwyn lobo <linux.melwyn@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: x86 memcpy performance
Message-ID: <20110909134233.GA1147@gere.osrc.amd.com>
References: <20110814095910.GA18809@liondog.tnic>
 <6296.1313462075@turing-police.cc.vt.edu>
 <20110816121604.GA29251@aftab>
 <4E5FA18A.7010205@gmail.com>
 <CA+55aFz1RRY6KcqVVZ9tBH7PDXfBwkZ1AhJcSHPABLXMkNJCOA@mail.gmail.com>
 <20110908083551.GA5646@liondog.tnic>
 <4E689FC5.8010005@gmail.com>
 <20110909081407.GA29251@liondog.tnic>
 <4E69E675.1010809@gmail.com>
 <4E69F71D.3030905@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="3lcZGd9BuhuYXNfi"
Content-Disposition: inline
In-Reply-To: <4E69F71D.3030905@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--3lcZGd9BuhuYXNfi
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Fri, Sep 09, 2011 at 01:23:09PM +0200, Maarten Lankhorst wrote:
> This specific one happened far more than any of the other memcpy usages, and
> ignoring the check when destination is page aligned, most of them are gone.
> 
> In short: I don't think I can get a speedup by using avx memcpy in-kernel.
> 
> YMMV, if it does speed up for you, I'd love to see concrete numbers. And not only worst
> case, but for the common aligned cases too. Or some concrete numbers that misaligned
> happens a lot for you.

Actually,

assuming alignment matters, I'd need to redo the trace_printk run I did
initially on buffer sizes:

http://marc.info/?l=linux-kernel&m=131331602309340 (kernel_build.sizes attached)

to get a more sensible grasp on the alignment of kernel buffers along
with their sizes and to see whether we're doing a lot of unaligned large
buffer copies in the kernel. I seriously doubt that, though, we should
be doing everything pagewise anyway so...

Concerning numbers, I ran your version again and sorted the output by
speedup. The highest scores are:

30037(12/44)	5566.4		12797.2		2.299011642
28672(12/44)	5512.97		12588.7		2.283467991
30037(28/60)	5610.34		12732.7		2.269502799
27852(12/44)	5398.36		12242.4		2.267803859
30037(4/36)	5585.02		12598.6		2.25578257
28672(28/60)	5499.11		12317.5		2.239914033
27852(28/60)	5349.78		11918.9		2.227919527
27852(20/52)	5335.92		11750.7		2.202186795
24576(12/44)	4991.37		10987.2		2.201247446

and this is pretty cool. Here are the (0/0) cases:

8192(0/0)       2627.82         3038.43         1.156255766
12288(0/0)      3116.62         3675.98         1.179475031
13926(0/0)      3330.04         4077.08         1.224334839
14336(0/0)      3377.95         4067.24         1.204055286
15018(0/0)      3465.3          4215.3          1.216430725
16384(0/0)      3623.33         4442.38         1.226050715
24576(0/0)      4629.53         6021.81         1.300737559
27852(0/0)      5026.69         6619.26         1.316823133
28672(0/0)      5157.73         6831.39         1.324495749
30037(0/0)      5322.01         6978.36         1.3112261

It is not 2x anymore but still.

Anyway, looking at the buffer sizes, they're rather ridiculous and even
if we get them in some workload, they won't repeat n times per second to
be relevant. So we'll see...

Thanks.

-- 
Regards/Gruss,
Boris.

--3lcZGd9BuhuYXNfi
Content-Type: text/plain; charset="us-ascii"; name="kernel_build.sizes"
Content-Disposition: attachment; filename="kernel_build.sizes"
Content-Description: kernel_build.sizes

Bytes	Count
=====	=====
0	5447
1	3850
2	16255
3	11113
4	68870
5	4256
6	30433
7	19188
8	50490
9	5999
10	78275
11	5628
12	6870
13	7371
14	4742
15	4911
16	143835
17	14096
18	1573
19	13603
20	424321
21	741
22	584
23	450
24	472
25	685
26	367
27	365
28	333
29	301
30	300
31	269
32	489
33	272
34	266
35	220
36	239
37	209
38	249
39	235
40	207
41	181
42	150
43	98
44	194
45	66
46	62
47	52
48	67226
49	138
50	171
51	26
52	20
53	12
54	15
55	4
56	13
57	8
58	6
59	6
60	115
61	10
62	5
63	12
64	67353
65	6
66	2363
67	9
68	11
69	6
70	5
71	6
72	10
73	4
74	9
75	8
76	4
77	6
78	3
79	4
80	3
81	4
82	4
83	4
84	4
85	8
86	6
87	2
88	3
89	2
90	2
91	1
92	9
93	1
94	2
96	2
97	2
98	3
100	2
102	1
104	1
105	1
106	1
107	2
109	1
110	1
111	1
112	1
113	2
115	2
117	1
118	1
119	1
120	14
127	1
128	1
130	1
131	2
134	2
137	1
144	100092
149	1
151	1
153	1
158	1
185	1
217	4
224	3
225	3
227	3
244	1
254	5
255	13
256	21708
512	21746
848	12907
1920	36536
2048	21708

--3lcZGd9BuhuYXNfi--
