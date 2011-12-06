Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933339Ab1LFNXQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 08:23:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57570 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933164Ab1LFNXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 08:23:13 -0500
Message-ID: <4EDE1733.8060409@redhat.com>
Date: Tue, 06 Dec 2011 11:22:59 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: HoP <jpetrous@gmail.com>
CC: Florian Fainelli <f.fainelli@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Andreas Oberritter <obi@linuxtv.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] vtunerc: virtual DVB device - is it ok to NACK driver because
 of worrying about possible misusage?
References: <CAJbz7-2T33c+2uTciEEnzRTaHF7yMW9aYKNiiLniH8dPUYKw_w@mail.gmail.com> <4ED6C5B8.8040803@linuxtv.org> <4ED75F53.30709@redhat.com> <CAJbz7-0td1FaDkuAkSGQRdgG5pkxjYMUGLDi0Y5BrBF2=6aVCw@mail.gmail.com> <20111202231909.1ca311e2@lxorguk.ukuu.org.uk> <CAJbz7-0Xnd30nJsb7SfT+j6uki+6PJpD77DY4zARgh_29Z=-+g@mail.gmail.com> <4EDC9B17.2080701@gmail.com> <CAJbz7-2maWS6mx9WHUWLiW8gC-2PxLD3nc-3y7o9hMtYxN6ZwQ@mail.gmail.com> <4EDD01BA.40208@redhat.com> <CAJbz7-1S6K=sDJFcOM8mMxL3t2JS91k+fHLy4gq868_9eUyS9A@mail.gmail.com>
In-Reply-To: <CAJbz7-1S6K=sDJFcOM8mMxL3t2JS91k+fHLy4gq868_9eUyS9A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05-12-2011 22:07, HoP wrote:
>> I doubt that scan or w_scan would support it. Even if it supports, that
>> would mean that,
>> for each ioctl that would be sent to the remote server, the error code would
>> take 480 ms
>> to return. Try to calculate how many time w_scan would work with that. The
>> calculus is easy:
>> see how many ioctl's are called by each frequency and multiply by the number
>> of frequencies
>> that it would be seek. You should then add the delay introduced over
>> streaming the data
>> from the demux, using the same calculus. This is the additional time over a
>> local w_scan.
>>
>> A grouch calculus with scandvb: to tune into a single DVB-C frequency, it
>> used 45 ioctls.
>> Each taking 480 ms round trip would mean an extra delay of 21.6 seconds.
>> There are 155
>> possible frequencies here. So, imagining that scan could deal with 21.6
>> seconds of delay
>> for each channel (with it doesn't), the extra delay added by it is 1 hour
>> (45 * 0.48 * 155).
>>
>> On the other hand, a solution like the one described by Florian would
>> introduce a delay of
>> 480 ms for the entire scan to happen, as only one data packet would be
>> needed to send a
>> scan request, and one one stream of packets traveling at 10GB/s would bring
>> the answer
>> back.
>
> Andreas was excited by your imaginations and calculations, but not me.
> Now you again manifested you are not treating me as partner for discussion.
> Otherwise you should try to understand how-that-ugly-hack works.
> But you surelly didn't try to do it at all.
>
> How do you find those 45 ioctls for DVB-C tune?

With strace. See how many ioctl's are called for each tune. Ok, perhaps scandvb
is badly written, but if your idea is to support 100% of the applications, you
should be prepared for badly written applications.

$strace -e ioctl scandvb dvbc-teste
scanning dvbc-teste
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
ioctl(3, FE_GET_INFO, 0x60a640)         = 0
initial transponder 573000000 5217000 0 5
>>> tune to: 573000000:INVERSION_AUTO:5217000:FEC_NONE:QAM_256
ioctl(3, FE_SET_FRONTEND, 0x7fff5f7f2cd0) = 0
ioctl(3, FE_READ_STATUS, 0x7fff5f7f2cfc) = 0
ioctl(3, FE_READ_STATUS, 0x7fff5f7f2cfc) = 0
ioctl(3, FE_READ_STATUS, 0x7fff5f7f2cfc) = 0
ioctl(4, DMX_SET_FILTER, 0x7fff5f7f1ad0) = 0
ioctl(5, DMX_SET_FILTER, 0x7fff5f7f1ad0) = 0
ioctl(6, DMX_SET_FILTER, 0x7fff5f7f1ad0) = 0
ioctl(7, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(8, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(9, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(10, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(11, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(12, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(13, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(14, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(15, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(16, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(17, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(18, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(19, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(20, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(21, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(22, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(23, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(24, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(4, DMX_STOP, 0x1)                 = 0
ioctl(15, DMX_STOP, 0x1)                = 0
ioctl(11, DMX_STOP, 0x1)                = 0
ioctl(22, DMX_STOP, 0x1)                = 0
ioctl(17, DMX_STOP, 0x1)                = 0
ioctl(16, DMX_STOP, 0x1)                = 0
0x0000 0x0004: pmt_pid 0x0108 (null) -- SBT (running)
0x0000 0x0005: pmt_pid 0x0250 (null) -- Globo (running)
0x0000 0x0007: pmt_pid 0x0128 (null) -- Record (running)
0x0000 0x000d: pmt_pid 0x0118 (null) -- Band (running)
0x0000 0x002e: pmt_pid 0x0148 (null) -- Cartoon Network (running, scrambled)
0x0000 0x0030: pmt_pid 0x0158 (null) -- TNT (running, scrambled)
0x0000 0x0039: pmt_pid 0x0168 (null) -- Boomerang (running, scrambled)
0x0000 0x0090: pmt_pid 0x0178 (null) -- DW-TV (running, scrambled)
0x0000 0x0098: pmt_pid 0x0188 (null) -- BBC World News (running, scrambled)
0x0000 0x00cb: pmt_pid 0x01a8 (null) -- NET Games (running)
0x0000 0x012c: pmt_pid 0x0198 (null) -- NET M�sica (running, scrambled)
0x0000 0x0133: pmt_pid 0x0022 (null) -- Pagode (running)
0x0000 0x0135: pmt_pid 0x0020 (null) -- Ax� (running)
0x0000 0x0146: pmt_pid 0x0023 (null) -- Festa (running)
0x0000 0x0156: pmt_pid 0x0024 (null) -- Trilhas Sonoras (running)
0x0000 0x015b: pmt_pid 0x0021 (null) -- Radio Multishow (running)
0x0000 0x0320: pmt_pid 0x02c4 (null) -- 01070136 (running)
0x0000 0x0321: pmt_pid 0x02c5 (null) -- 01070236 (running)
ioctl(5, DMX_STOP, 0x1)                 = 0
ioctl(24, DMX_STOP, 0x1)                = 0
ioctl(23, DMX_STOP, 0x1)                = 0
ioctl(7, DMX_STOP, 0x1)                 = 0
ioctl(19, DMX_STOP, 0x1)                = 0
ioctl(18, DMX_STOP, 0x1)                = 0
ioctl(21, DMX_STOP, 0x1)                = 0
ioctl(12, DMX_STOP, 0x1)                = 0
ioctl(13, DMX_STOP, 0x1)                = 0
ioctl(20, DMX_STOP, 0x1)                = 0
ioctl(10, DMX_STOP, 0x1)                = 0
ioctl(9, DMX_STOP, 0x1)                 = 0
ioctl(8, DMX_STOP, 0x1)                 = 0
ioctl(14, DMX_STOP, 0x1)                = 0
Network Name 'NET SJC'
ioctl(6, DMX_STOP, 0x1)                 = 0
>>> tune to: 591000000:INVERSION_AUTO:5217000:FEC_3_4:QAM_256
ioctl(3, FE_SET_FRONTEND, 0x7fff5f7f2cd0) = 0
ioctl(3, FE_READ_STATUS, 0x7fff5f7f2cfc) = 0
ioctl(3, FE_READ_STATUS, 0x7fff5f7f2cfc) = 0
ioctl(3, FE_READ_STATUS, 0x7fff5f7f2cfc) = 0
ioctl(4, DMX_SET_FILTER, 0x7fff5f7f1ad0) = 0
ioctl(5, DMX_SET_FILTER, 0x7fff5f7f1ad0) = 0
ioctl(6, DMX_SET_FILTER, 0x7fff5f7f1ad0) = 0
ioctl(7, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(8, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(9, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(10, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(11, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(12, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(13, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(14, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(15, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(16, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(17, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(18, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(19, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(4, DMX_STOP, 0x1)                 = 0
ioctl(9, DMX_STOP, 0x1)                 = 0
ioctl(10, DMX_STOP, 0x1)                = 0
ioctl(12, DMX_STOP, 0x1)                = 0
ioctl(11, DMX_STOP, 0x1)                = 0
ioctl(14, DMX_STOP, 0x1)                = 0
ioctl(8, DMX_STOP, 0x1)                 = 0
ioctl(7, DMX_STOP, 0x1)                 = 0
ioctl(13, DMX_STOP, 0x1)                = 0
ioctl(15, DMX_STOP, 0x1)                = 0
0x0090 0x0029: pmt_pid 0x0468 (null) -- GNT (running, scrambled)
0x0090 0x002a: pmt_pid 0x0458 (null) -- Multishow (running, scrambled)
0x0090 0x002f: pmt_pid 0x0077 (null) -- Warner Channel (running, scrambled)
0x0090 0x0042: pmt_pid 0x0478 (null) -- Canal Brasil (running, scrambled)
0x0090 0x0046: pmt_pid 0x0438 (null) -- ESPN Brasil (running, scrambled)
0x0090 0x0049: pmt_pid 0x0428 (null) -- HBO2 (running, scrambled)
0x0090 0x007c: pmt_pid 0x0488 (null) -- Premiere FC (running, scrambled)
0x0090 0x008c: pmt_pid 0x0108 (null) -- RAI (running, scrambled)
0x0090 0x0099: pmt_pid 0x0408 (null) -- CNN International (running, scrambled)
0x0090 0x013e: pmt_pid 0x0021 (null) -- Anos 80 (running)
0x0090 0x014d: pmt_pid 0x0022 (null) -- Blues (running)
0x0090 0x014e: pmt_pid 0x0023 (null) -- Rhythm & Blues (running)
0x0090 0x014f: pmt_pid 0x0020 (null) -- Standards (running)
ioctl(5, DMX_STOP, 0x1)                 = 0
ioctl(17, DMX_STOP, 0x1)                = 0
ioctl(18, DMX_STOP, 0x1)                = 0
ioctl(16, DMX_STOP, 0x1)                = 0
ioctl(19, DMX_STOP, 0x1)                = 0
Network Name 'NET SJC'
ioctl(6, DMX_STOP, 0x1)                 = 0
>>> tune to: 597000000:INVERSION_AUTO:5217000:FEC_3_4:QAM_256
ioctl(3, FE_SET_FRONTEND, 0x7fff5f7f2cd0) = 0
ioctl(3, FE_READ_STATUS, 0x7fff5f7f2cfc) = 0
ioctl(3, FE_READ_STATUS, 0x7fff5f7f2cfc) = 0
ioctl(3, FE_READ_STATUS, 0x7fff5f7f2cfc) = 0
ioctl(4, DMX_SET_FILTER, 0x7fff5f7f1ad0) = 0
ioctl(5, DMX_SET_FILTER, 0x7fff5f7f1ad0) = 0
ioctl(6, DMX_SET_FILTER, 0x7fff5f7f1ad0) = 0
ioctl(7, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(8, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(9, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(10, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(11, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(12, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(13, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(14, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(15, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(16, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(17, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(18, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(19, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(4, DMX_STOP, 0x1)                 = 0
ioctl(9, DMX_STOP, 0x1)                 = 0
ioctl(19, DMX_STOP, 0x1)                = 0
ioctl(18, DMX_STOP, 0x1)                = 0
ioctl(7, DMX_STOP, 0x1)                 = 0
0x0091 0x0010: pmt_pid 0x0e08 (null) -- TV Senado (running)
0x0091 0x0013: pmt_pid 0x0518 (null) -- Rede Vida (running)
0x0091 0x0023: pmt_pid 0x0508 (null) -- Canal Rural (running, scrambled)
0x0091 0x0038: pmt_pid 0x0578 (null) -- Disney XD (running, scrambled)
0x0091 0x003d: pmt_pid 0x0558 (null) -- Telecine Premium (running, scrambled)
0x0091 0x0041: pmt_pid 0x0568 (null) -- Telecine Cult (running, scrambled)
0x0091 0x0043: pmt_pid 0x0588 (null) -- Disney Channel (running, scrambled)
0x0091 0x005d: pmt_pid 0x0528 (null) -- Record News (running, scrambled)
0x0091 0x008d: pmt_pid 0x138f (null) -- TV5 (running, scrambled)
0x0091 0x0134: pmt_pid 0x0020 (null) -- Samba de Raiz (running)
0x0091 0x0149: pmt_pid 0x0021 (null) -- New Age (running)
0x0091 0x0151: pmt_pid 0x0022 (null) -- Jazz Contemporaneo (running)
0x0091 0x0152: pmt_pid 0x0023 (null) -- M�sica Cl�ssica (running)
ioctl(5, DMX_STOP, 0x1)                 = 0
ioctl(16, DMX_STOP, 0x1)                = 0
ioctl(14, DMX_STOP, 0x1)                = 0
ioctl(12, DMX_STOP, 0x1)                = 0
ioctl(10, DMX_STOP, 0x1)                = 0
ioctl(8, DMX_STOP, 0x1)                 = 0
ioctl(17, DMX_STOP, 0x1)                = 0
ioctl(11, DMX_STOP, 0x1)                = 0
ioctl(15, DMX_STOP, 0x1)                = 0
ioctl(13, DMX_STOP, 0x1)                = 0
Network Name 'NET SJC'
ioctl(6, DMX_STOP, 0x1)                 = 0
>>> tune to: 603000000:INVERSION_AUTO:5217000:FEC_3_4:QAM_256
ioctl(3, FE_SET_FRONTEND, 0x7fff5f7f2cd0) = 0
ioctl(3, FE_READ_STATUS, 0x7fff5f7f2cfc) = 0
ioctl(3, FE_READ_STATUS, 0x7fff5f7f2cfc) = 0
ioctl(3, FE_READ_STATUS, 0x7fff5f7f2cfc) = 0
ioctl(4, DMX_SET_FILTER, 0x7fff5f7f1ad0) = 0
ioctl(5, DMX_SET_FILTER, 0x7fff5f7f1ad0) = 0
ioctl(6, DMX_SET_FILTER, 0x7fff5f7f1ad0) = 0
ioctl(7, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(8, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(9, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(10, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(11, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(12, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(13, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(14, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(15, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(16, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(17, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(18, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(19, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(4, DMX_STOP, 0x1)                 = 0
ioctl(8, DMX_STOP, 0x1)                 = 0
ioctl(14, DMX_STOP, 0x1)                = 0
ioctl(7, DMX_STOP, 0x1)                 = 0
ioctl(9, DMX_STOP, 0x1)                 = 0
ioctl(10, DMX_STOP, 0x1)                = 0
ioctl(17, DMX_STOP, 0x1)                = 0
ioctl(18, DMX_STOP, 0x1)                = 0
ioctl(12, DMX_STOP, 0x1)                = 0
ioctl(13, DMX_STOP, 0x1)                = 0
0x0092 0x0028: pmt_pid 0x0668 (null) -- Globo News (running, scrambled)
0x0092 0x002b: pmt_pid 0x0658 (null) -- Universal Channel (running, scrambled)
0x0092 0x002c: pmt_pid 0x0628 (null) -- Nickelodeon (running, scrambled)
0x0092 0x003e: pmt_pid 0x0608 (null) -- Telecine Action (running, scrambled)
0x0092 0x003f: pmt_pid 0x0618 (null) -- Telecine Touch (running, scrambled)
0x0092 0x0058: pmt_pid 0x0688 (null) -- VH1 Mega Hits (running, scrambled)
0x0092 0x0059: pmt_pid 0x0648 (null) -- VH1 (running, scrambled)
0x0092 0x007e: pmt_pid 0x139a (null) -- Aquecimento BBB12 (running, scrambled)
0x0092 0x011d: pmt_pid 0x0678 (null) -- Sexy Hot (running, scrambled)
0x0092 0x0131: pmt_pid 0x0024 (null) -- R�dio Kids (running)
0x0092 0x0137: pmt_pid 0x0020 (null) -- Forr� (running)
0x0092 0x0148: pmt_pid 0x0023 (null) -- Lounge (running)
0x0092 0x0153: pmt_pid 0x0022 (null) -- M�sica Orquestrada (running)
ioctl(5, DMX_STOP, 0x1)                 = 0
ioctl(11, DMX_STOP, 0x1)                = 0
ioctl(19, DMX_STOP, 0x1)                = 0
ioctl(15, DMX_STOP, 0x1)                = 0
Network Name 'NET SJC'
ioctl(16, DMX_STOP, 0x1)                = 0
ioctl(6, DMX_STOP, 0x1)                 = 0
>>> tune to: 609000000:INVERSION_AUTO:5217000:FEC_3_4:QAM_256
ioctl(3, FE_SET_FRONTEND, 0x7fff5f7f2cd0) = 0
ioctl(3, FE_READ_STATUS, 0x7fff5f7f2cfc) = 0
ioctl(3, FE_READ_STATUS, 0x7fff5f7f2cfc) = 0
ioctl(3, FE_READ_STATUS, 0x7fff5f7f2cfc) = 0
ioctl(4, DMX_SET_FILTER, 0x7fff5f7f1ad0) = 0
ioctl(5, DMX_SET_FILTER, 0x7fff5f7f1ad0) = 0
ioctl(6, DMX_SET_FILTER, 0x7fff5f7f1ad0) = 0
ioctl(7, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(8, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(9, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(10, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(11, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(12, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(13, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(14, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(15, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(16, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(17, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(18, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(19, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(20, DMX_SET_FILTER, 0x7fff5f7f1910) = 0
ioctl(4, DMX_STOP, 0x1)                 = 0
ioctl(9, DMX_STOP, 0x1)                 = 0
ioctl(17, DMX_STOP, 0x1)                = 0
ioctl(20, DMX_STOP, 0x1)                = 0
ioctl(10, DMX_STOP, 0x1)                = 0
ioctl(19, DMX_STOP, 0x1)                = 0
ioctl(13, DMX_STOP, 0x1)                = 0
ioctl(14, DMX_STOP, 0x1)                = 0
ioctl(16, DMX_STOP, 0x1)                = 0
ioctl(15, DMX_STOP, 0x1)                = 0
ioctl(7, DMX_STOP, 0x1)                 = 0
ioctl(18, DMX_STOP, 0x1)                = 0
ioctl(11, DMX_STOP, 0x1)                = 0
ioctl(8, DMX_STOP, 0x1)                 = 0
ioctl(12, DMX_STOP, 0x1)                = 0
0x0093 0x000a: pmt_pid 0x0708 (null) -- NET Cidade (running)
0x0093 0x0012: pmt_pid 0x0728 (null) -- Rede Mundial (running)
0x0093 0x0014: pmt_pid 0x0738 (null) -- Rede 21 (running, scrambled)
0x0093 0x0015: pmt_pid 0x011f (null) -- TV Justi�a (running)
0x0093 0x0026: pmt_pid 0x0758 (null) -- SporTV2 (running, scrambled)
0x0093 0x0027: pmt_pid 0x0748 (null) -- SporTV (running, scrambled)
0x0093 0x0036: pmt_pid 0x0768 (null) -- FX (running, scrambled)
0x0093 0x0052: pmt_pid 0x0788 (null) -- The History Channel (running, scrambled)
0x0093 0x0060: pmt_pid 0x0778 (null) -- Fox Life (running, scrambled)
0x0093 0x0136: pmt_pid 0x0020 (null) -- Sertanejo (running)
0x0093 0x0140: pmt_pid 0x0024 (null) -- Rock Cl�ssico (running)
0x0093 0x0143: pmt_pid 0x0022 (null) -- Reggae (running)
0x0093 0x0147: pmt_pid 0x0023 (null) -- Eletr�nica (running)
0x0093 0x015d: pmt_pid 0x0021 (null) -- CBN (running)
ioctl(5, DMX_STOP, 0x1)                 = 0
Network Name 'NET SJC'
ioctl(6, DMX_STOP, 0x1)                 = 0
...
