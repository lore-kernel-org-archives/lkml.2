Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971Ab2CCX2a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 18:28:30 -0500
Received: from mx2.parallels.com ([64.131.90.16]:40229 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381Ab2CCX23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 18:28:29 -0500
Message-ID: <4F52A8D5.9090703@parallels.com>
Date: Sat, 3 Mar 2012 20:27:17 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Sergei Trofimovich <slyich@gmail.com>
CC: Jason Wang <jasowang@redhat.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCHv 2] tcp: properly initialize tcp memory limits part 2
 (fix nfs regression)
References: <1330675173-18968-1-git-send-email-slyich@gmail.com> <4F509150.5060904@redhat.com> <20120302202421.753b36bc@sf.home> <20120302205000.088bf231@sf.home> <4F5227C9.7060209@parallels.com> <20120303174322.7e920bc5@sf.home>
In-Reply-To: <20120303174322.7e920bc5@sf.home>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [201.82.131.123]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2012 11:43 AM, Sergei Trofimovich wrote:
> On Sat, 3 Mar 2012 11:16:41 -0300
> Glauber Costa<glommer@parallels.com>  wrote:
>
>> On 03/02/2012 02:50 PM, Sergei Trofimovich wrote:
>>>>>> The change looks like a typo (division flipped to multiplication):
>>>>>>> limit = nr_free_buffer_pages() / 8;
>>>>>>> limit = nr_free_buffer_pages()<<    (PAGE_SHIFT - 10);
>>>>>
>>>>> Hi, thanks for the reporting. It's not a typo. It was previously:
>>>>> sysctl_tcp_mem[1]<<   (PAGE_SHIFT -  7). Looks like we need to do the
>>>>> limit check before shift the value. Please try the following patch, thanks.
>>>>
>>>> Still does not help. I test it by checking sha1sum of a large file over NFS
>>>> (small files seem to work simetimes):
>>>>
>>>>       $ strace sha1sum /gentoo/distfiles/gcc-4.6.2.tar.bz2
>>>>       ...
>>>>       open("/gentoo/distfiles/gcc-4.6.2.tar.bz2", O_RDONLY
>>>>       <HUNG>
>>>> After a certain timeout dmesg gets odd spam:
>>>> [  314.848094] nfs: server vmhost not responding, still trying
>>>> [  314.848134] nfs: server vmhost not responding, still trying
>>>> [  314.848145] nfs: server vmhost not responding, still trying
>>>> [  314.957047] nfs: server vmhost not responding, still trying
>>>> [  314.957066] nfs: server vmhost not responding, still trying
>>>> [  314.957075] nfs: server vmhost not responding, still trying
>>>> [  314.957085] nfs: server vmhost not responding, still trying
>>>> [  314.957100] nfs: server vmhost not responding, still trying
>>>> [  314.958023] nfs: server vmhost not responding, still trying
>>>> [  314.958035] nfs: server vmhost not responding, still trying
>>>> [  314.958044] nfs: server vmhost not responding, still trying
>>>> [  314.958054] nfs: server vmhost not responding, still trying
>>>>
>>>> looks like bogus messages. Might be relevant to mishandled timings
>>>> somewhere else or a bug in nfs code.
>>>
>>> And after 120 seconds hung tasks shows it might be an OOM issue
>>> Likely caused by patch, as it's a 2GB RAM +4GB swap amd64 box
>>> not running anything heavy:
>>
>> That is a bit weird.
>>
>> First because with Jason's patch, we should end up with the very same
>> calculation, at the same exact order, as it was in older kernels.
>> Second, because by shifting<<  10, you should be ending up with very
>> small numbers, effectively having tcp_rmem[1] == tcp_rmem[2], and the
>> same for wmem.
>>
>> Can you share which numbers you end up with at
>> /proc/sys/net/ipv4/tcp_{r,w}mem ?
>>
>
> Sure:
>
>      $ cat /proc/sys/net/ipv4/tcp_{r,w}mem
>      4096    87380   1999072
>      4096    16384   1999072
>
Sergei,

Sorry for not being clearer. I was expecting you'd post those values
both in the scenario in which you see the bug, and in the scenario you
don't.

> Nothing special with NFS nere, so I guess it uses UDP.
> TCP works fine on machine (I do everything via SSH).

Can you confirm that? If you're using nfs through udp, it makes
even less sense that the default values of tcp sock mem will harm
you. So it might be a bug somewhere else...



