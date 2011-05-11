Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413Ab1EKRY0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 13:24:26 -0400
Received: from wega.rz.tu-ilmenau.de ([141.24.4.159]:59992 "EHLO
	wega.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab1EKRYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 13:24:25 -0400
Message-ID: <4DCAC8FC.5060505@tu-ilmenau.de>
Date: Wed, 11 May 2011 19:35:56 +0200
From: =?UTF-8?B?U3RlcGhhbiBCw6Ryd29sZg==?= 
	<stephan.baerwolf@tu-ilmenau.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110509 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Nikhil Rao <ncrao@google.com>, Mike Galbraith <efault@gmx.de>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: fix/optimise calculation of weight-inverse
References: <4DCAB351.4010204@tu-ilmenau.de> <20110511162030.GA2638@elte.hu> <1305132185.2914.251.camel@laptop>
In-Reply-To: <1305132185.2914.251.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>I think what we wanted to do was minimize the error:
>  err = weight - inv*WMULT_CONST

Hi all,
thanks for your fast response.
I think what you mean is:

err = | WMULT_CONST - inv*weight |  --> min

right?

But the following table(s) shows the difference in the inverses:
(assuming WMULT_CONST = 2**32 as on x64)

weight                                    oldway
inv_weigth                 new inv_weight

1                                             2147483649 (=1+2**31)    
4294967295 [=(2**32)-1]    
2                                            
1431655766                         2147483647
3 (= WEIGHT_IDLEPRIO)        1073741824                         1431655765
15 (= nice 19)                        
268435456                           286331153
1024 (=nice 0)                       
4190212                               4194304
...
...
88761 (=nice -20)                  
48387                                   48388

----

weight                                    err
oldway                             err newway

1                                             2147483647 (=2**31 - 1)   
1     
2                                             1431655764
                        2
3 (= WEIGHT_IDLEPRIO)        1073741824                         1
15 (= nice 19)                         268435456                           1
1024 (=nice 0)                       
4190208                               0
...
...
88761 (=nice -20)                   88789
                                  28



Thus the "err" of the old way can become very large (up to about  2^31 ).
And of course the new error increases with increasing weight, it is
still alway
smaller than the oldway err (because oldway inv converts to newway inv)...


regards Stephan

--
Dipl.-Inf. Stephan Bärwolf
Ilmenau University of Technology, Integrated Communication Systems Group
Phone: +49 (0)3677 69 2821,  FAX: +49 (0)3677 69 1614
Email: stephan.baerwolf@tu-ilmenau.de,
Web: http://www.tu-ilmenau.de/iks


