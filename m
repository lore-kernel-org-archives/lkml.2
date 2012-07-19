Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784Ab2GSQO4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 12:14:56 -0400
Received: from tharradin.pu-pm.univ-fcomte.fr ([194.57.85.210]:47743 "EHLO
	tharradin.pu-pm.univ-fcomte.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751337Ab2GSQOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 12:14:53 -0400
Message-ID: <50083279.8030101@pu-pm.univ-fcomte.fr>
Date: Thu, 19 Jul 2012 18:14:49 +0200
From: Eugen Dedu <Eugen.Dedu@pu-pm.univ-fcomte.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Rick Jones <rick.jones2@hp.com>
CC: Eric Dumazet <eric.dumazet@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: getsockopt/setsockopt with SO_RCVBUF and SO_SNDBUF "non-standard"
 behaviour
References: <50052FFE.2060109@pu-pm.univ-fcomte.fr>  <5006DD6B.3030300@pu-pm.univ-fcomte.fr> <1342627875.2626.3070.camel@edumazet-glaptop> <5006F32E.8060405@hp.com>
In-Reply-To: <5006F32E.8060405@hp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/07/12 19:32, Rick Jones wrote:
> On 07/18/2012 09:11 AM, Eric Dumazet wrote:
>>
>> That the way it's done on linux since day 0
>>
>> You can probably find a lot of pages on the web explaining the
>> rationale.
>>
>> If your application handles UDP frames, what SO_RCVBUF should count ?
>>
>> If its the amount of payload bytes, you could have a pathological
>> situation where an attacker sends 1-byte UDP frames fast enough and
>> could consume a lot of kernel memory.
>>
>> Each frame consumes a fair amount of kernel memory (between 512 bytes
>> and 8 Kbytes depending on the driver).
>>
>> So linux says : If user expect to receive XXXX bytes, set a limit of
>> _kernel_ memory used to store these bytes, and use an estimation of 100%
>> of overhead. That is : allow 2*XXXX bytes to be allocated for socket
>> receive buffers.
>
> Expanding on/rewording that, in a setsockopt() call SO_RCVBUF specifies
> the data bytes and gets doubled to become the kernel/overhead byte
> limit. Unless the doubling would be greater than net.core.rmem_max, in
> which case the limit becomes net.core.rmem_max.
>
> But on getsockopt() SO_RCVBUF is always the kernel/overhead byte limit.
>
> In one call it is fish. In the other it is fowl.
>
> Other stacks appear to keep their kernel/overhead limit quiet, keeping
> SO_RCVBUF an expression of a data limit in both setsockopt() and
> getsockopt(). With those stacks, there is I suppose the possible source
> of confusion when/if someone tests the queuing to a socket, sends "high
> overhead" packets and doesn't get to SO_RCVBUF worth of data though I
> don't recall encountering that in my "pre-linux" time.

Thank you to both for the answers.  As I understand, it it is impossible 
(or not practical) to fulfill sometimes user requirements on buff size, 
since if only 1-byte udp packets arrive and are not consumed by 
application, the memory needed by linux is say 1000 greater, which of 
course is not available.  Other OSes have the same problem (see above 
"doesn't get to SO_RCVBUF worth of data"), except that they return the 
same value in getsockopt as setsockopt.  However, note that with linux 
the confusion is still possible, even if it appears more rarely.

> The sometimes fish, sometimes fowl version (along with the auto tuning
> when one doesn't make setsockopt() calls) gave me fits in netperf for
> years until I finally relented and split the socket buffer size
> variables into three - what netperf's user requested via the command
> line, what it was right after the socket was created, and what it was at
> the end of the data phase of the test.

-- 
Eugen
