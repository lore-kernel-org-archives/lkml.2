Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377Ab0HPRCP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 13:02:15 -0400
Received: from mx0.vr-web.de ([195.200.35.198]:51250 "EHLO mx0.vr-web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752700Ab0HPRCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 13:02:14 -0400
Message-ID: <4C696F81.9070406@01019freenet.de>
Date: Mon, 16 Aug 2010 19:04:01 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.3a6pre) Gecko/20100803 SeaMonkey/2.1a2
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: users@rt2x00.serialmonkey.com,
        Kernel-Mailingliste <linux-kernel@vger.kernel.org>
Subject: Re: rt61pci - bad performance
References: <ffaPE-58l-5@gated-at.bofh.it> <fgXXY-KJ-1@gated-at.bofh.it> <4C6659F5.9080706@01019freenet.de> <201008160901.57487.helmut.schaa@googlemail.com>
In-Reply-To: <201008160901.57487.helmut.schaa@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-BitDefender-Scanner: Clean, Agent: BitDefender Courier 3.0.2 on
 vrwf103, sigver: 7.28621
X-BitDefender-CF-Stamp: none
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Helmut Schaa wrote:
> Added rt2x00 mailinglist to CC ...
>
> Am Saturday 14 August 2010 schrieb Andreas:
>> Helmut Schaa wrote:
>>> Hi Andreas,
>>>
>>> Am Freitag 13 August 2010 schrieb Andrew Morton:
>>>> (cc's added)
>>>>
>>>> On Sun, 08 Aug 2010 11:49:49 +0200
>>>> Andreas<andihartmann@01019freenet.de>   wrote:
>>>
>>> [...]
>>>
>>>>> wlan0     IEEE 802.11bg  ESSID:"--------"
>>>>>              Mode:Managed  Frequency:2.412 GHz  Access Point: some AP
>>>>>              Bit Rate=1 Mb/s   Tx-Power=5 dBm
>>>>>              Retry  long limit:7   RTS thr:off   Fragment thr:off
>>>>>              Encryption key:off
>>>>>              Power Management:off
>>>>>              Link Quality=38/70  Signal level=-72 dBm
>>>>>              Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>>>>>              Tx excessive retries:0  Invalid misc:0   Missed beacon:0
>>>>>
>>>>> The throughput is measured with ping -f -s 7000 and xosview -n.
>>>
>>> This doesn't look like an appropriate way to measure the throughput. You
>>> should use something like iperf [1] or netperf [2] for your measurements
>>> to get more accurate results.
>>>
>>>>> If I'm using ndiswrapper with the windows driver, first of all, I can
>>>>> see additional information in iwconfig:
>>>>>
>>>>> wlan0     IEEE 802.11g  ESSID:"--------"
>>>>>              Mode:Managed  Frequency:2.412 GHz  Access Point: some AP
>>>>>              Bit Rate=54 Mb/s   Tx-Power:20 dBm   Sensitivity=-121 dBm
>>>>>              RTS thr=2347 B   Fragment thr=2346 B
>>>>>              Encryption key:some key   Security mode:restricted
>>>>>              Power Management:off
>>>>>              Link Quality:62/100  Signal level:-56 dBm  Noise level:-96 dBm
>>>>>              Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>>>>>              Tx excessive retries:0  Invalid misc:0   Missed beacon:0
>>>>>
>>>>>
>>>>> There is a switch for sensitivity (which is not supported with rt61pci)
>>>>> and the link quality compared with ndiswrapper is worse (38% to 62%).
>>>
>>> I wouldn't trust the link quality values that much, the calculation in rt61pi
>>> is most likely different from what the windows driver does. So it is not
>>> really comparable.
>>
>> I detected the problem using tunneled ssh-x-sessions and during copying
>> of data. I'm not really interested in the link-quality - I just need a
>> high performance :-).
>>
>>>>> The following is remarkably too:
>>>>> ndiswrapper uses a Tx-Power of 20 dBm, rt61pci only 5 dBm. I don't know,
>>>>> why rt61pci uses 5 dBm. It's a hard limit and I can't set it on a value
>>>>> higher than 5 unless the driver is patched. Nevertheless, setting a
>>>>> higher value (of 20 dBm) by patch does not mean to get a better performance.
>>>
>>> Could you elaborate please? Did you actually try to patch it or is this just
>>> an assumption?
>>
>> see my other mail!
>>
>>>>> Ndiswrapper shows an encryption key, rt61pci not. Does it mean, that
>>>>> rt61pci doesn't use hardware encryption?
>>>
>>> hw crypto should be enabled by default in rt61pci, however, I don't know
>>> if it is actually working ;)
>>
>> How can I see if it's working?
>
> You can add a printk to rt61pci_fill_rxdone, something like:
>
> diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
> index e539c6c..aa1aafd 100644
> --- a/drivers/net/wireless/rt2x00/rt61pci.c
> +++ b/drivers/net/wireless/rt2x00/rt61pci.c
> @@ -2023,6 +2023,7 @@ static void rt61pci_fill_rxdone(struct queue_entry *entry,
>   			rxdesc->flags |= RX_FLAG_DECRYPTED;
>   		else if (rxdesc->cipher_status == RX_CRYPTO_FAIL_MIC)
>   			rxdesc->flags |= RX_FLAG_MMIC_ERROR;
> +		printk(KERN_INFO "rt61pci_fill_rxdone: %x\n", rxdesc->cipher_status);
>   	}
>
>   	/*
>
>
>>>>> With ndiswrapper, the rt61pci-chip achieves a throughput of 2,6 MBytes/s
>>>>> - that's about 1 MByte/s more than rt61pci.
>>>>>
>>>>> I have to say, that the difference between rt61pci and ndiswrapper gets
>>>>> worse if the link quality is getting more badly. Or in other words:
>>>>> ndiswrapper handles bad connections better then rt61pci.
>>>>>
>>>>>
>>>>> Do you have any idea to get rt61pci working as fast as ndiswrapper?
>>>
>>> Please run proper measurements first and post the results again.
>>
>> I did some measurements with netperf (TCP_STREAM):
>>
>>
>> ndiswrapper
>> ===========
>>
>> (OpenSuSE 11.2 2.6.31.13-21):
>> download
>> average        min        max
>> 20,88        19,02        22,19 MBit/s    (6 runs)
>>
>> upstream
>> average        min        max
>> 21,46        18,84        22,26 MBits/s    (7 runs)
>>
>>
>> OpenSuSE 11.3 (2.6.34-12-desktop)
>> download
>> average        min        max
>> 21,41        20,51        22,51 MBit/s    (16 runs)
>>
>>
>> upstream
>> average        min        max
>> error
>>
>>
>> rt61pci (patched - compat-wireless-2010-07-20)
>> ==============================================
>>
>> OpenSuSE 11.3 (2.6.34-12-desktop)
>> download
>> average        min        max
>> 15,54        12,4        17,19 MBit/s    (25 runs)
>>
>> upstream
>> average        min        max
>> 13,54        12,1        14,04 MBits/s    (7 runs)
>
> Hmm, ok that's quite a difference. Could you please mount debugfs
> (mount -t debugfs none /mnt), rerun the test and attach the contents
> of /mnt/ieee80211/phy0/stations/XX\:XX\:XX\:XX\:XX\:XX/rc_stats
> afterwards (XX:XX:XX:XX:XX:XX is the BSSID your connected to).

Wel, I did some tests. I tried to get same conditions (what is not as 
easy). I will show here some results, which seem to be typical to me.


downstream
==========

netperf -t TCP_SENDFILE -H client
TCP SENDFILE TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to client port 0 
AF_INET
Recv   Send    Send
Socket Socket  Message  Elapsed
Size   Size    Size     Time     Throughput
bytes  bytes   bytes    secs.    10^6bits/sec

  87380  16384  16384    10.36      16.38


/sys/kernel/debug/ieee80211/phy0/stations/xx:xx:xx:xx:xx:xx # cat rc_stats
rate     throughput  ewma prob   this prob  this succ/attempt   success 
    attempts
      1         0.7       76.2      100.0          0(  0)         11 
    11
      2         0.0        0.0        0.0          0(  0)          0 
     0
      5.5       0.0        0.0        0.0          0(  0)          0 
     0
     11         0.0        0.0        0.0          0(  0)          0 
     2
      6         0.0        0.0        0.0          0(  0)          0 
    32
      9         0.0        0.0        0.0          0(  0)        551 
  1574
     12         0.0        0.0        0.0          0(  0)       2096 
  6862
     18        11.3       69.9       66.6          0(  0)      18047 
25158
  t  24        13.4       62.9      100.0          0(  0)      29100 
42883
T P 36        28.2       92.8      100.0          1(  1)     135030  175797
     48         4.4       11.3        0.0          0(  0)        361 
  3646
     54         0.8        1.8        0.0          0(  0)         55 
  1727

Total packet count::    ideal 8917      lookaround 991



netperf -t TCP_STREAM -H client
TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to client port 0 
AF_INET
Recv   Send    Send
Socket Socket  Message  Elapsed
Size   Size    Size     Time     Throughput
bytes  bytes   bytes    secs.    10^6bits/sec

  87380  16384  16384    10.39      16.57


/sys/kernel/debug/ieee80211/phy0/stations/xx:xx:xx:xx:xx:xx # cat rc_stats
rate     throughput  ewma prob   this prob  this succ/attempt   success 
    attempts
      1         0.7       76.2      100.0          0(  0)         11 
    11
      2         0.0        0.0        0.0          0(  0)          0 
     0
      5.5       0.0        0.0        0.0          0(  0)          0 
     0
     11         0.0        0.0        0.0          0(  0)          0 
     2
      6         0.0        0.0        0.0          0(  0)          0 
    32
      9         0.0        0.0        0.0          0(  0)        551 
  1614
     12         0.0        0.0        0.0          0(  0)       2096 
  7047
  t  18        12.8       79.2       80.0          0(  0)      18647 
25949
     24         9.9       46.7      100.0          0(  0)      29439 
44023
T P 36        29.0       95.6      100.0          1(  1)     141588  183495
     48         5.2       13.3       50.0          0(  0)        380 
  3781
     54        12.4       28.6      100.0          0(  0)         60 
  1797

Total packet count::    ideal 6867      lookaround 763




upstream:
========

netperf -t TCP_MAERTS -H client
TCP MAERTS TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET client port 0 AF_INET
Recv   Send    Send
Socket Socket  Message  Elapsed
Size   Size    Size     Time     Throughput
bytes  bytes   bytes    secs.    10^6bits/sec

  87380  16384  16384    10.56      13.19


/sys/kernel/debug/ieee80211/phy0/stations/xx:xx:xx:xx:xx:xx # cat rc_stats
rate     throughput  ewma prob   this prob  this succ/attempt   success 
    attempts
      1         0.7       76.2      100.0          0(  0)         11 
    11
      2         0.0        0.0        0.0          0(  0)          0 
     0
      5.5       0.0        0.0        0.0          0(  0)          0 
     0
     11         0.0        0.0        0.0          0(  0)          0 
     2
      6         0.0        0.0        0.0          0(  0)          0 
    32
      9         0.0        0.0        0.0          0(  0)        551 
  1723
     12         6.8       61.8      100.0          0(  0)       2122 
  7635
   P 18        16.0       98.6      100.0          0(  0)      21199 
29108
  t  24        16.6       78.2      100.0          0(  0)      44090 
61942
T   36        29.1       95.7      100.0          1(  1)     183435  238929
     48         0.0        0.0        0.0          0(  0)        446 
  4861
     54         0.0        0.0        0.0          0(  0)         67 
  2340

Total packet count::    ideal 6696      lookaround 743



netperf -t TCP_MAERTS -H client
TCP MAERTS TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to client port 0 
AF_INET
Recv   Send    Send
Socket Socket  Message  Elapsed
Size   Size    Size     Time     Throughput
bytes  bytes   bytes    secs.    10^6bits/sec

  87380  16384  16384    10.39      13.38


/sys/kernel/debug/ieee80211/phy0/stations/xx:xx:xx:xx:xx:xx # cat rc_stats
rate     throughput  ewma prob   this prob  this succ/attempt   success 
    attempts
      1         0.7       76.2      100.0          0(  0)         11 
    11
      2         0.0        0.0        0.0          0(  0)          0 
     0
      5.5       0.0        0.0        0.0          0(  0)          0 
     0
     11         0.0        0.0        0.0          0(  0)          0 
     2
      6         0.0        0.0        0.0          0(  0)          0 
    32
      9         0.0        0.0        0.0          0(  0)        551 
  1534
     12         0.0        0.0        0.0          0(  0)       2096 
  6669
     18        15.5       95.4      100.0          0(  0)      17433 
24342
  tP 24        20.9       98.3      100.0          0(  0)      28782 
41742
T   36        28.9       95.2      100.0          1(  1)     128587  168213
     48         0.0        0.0        0.0          0(  0)        341 
  3510
     54         0.0        0.0        0.0          0(  0)         54 
  1658

Total packet count::    ideal 2073      lookaround 230


It's remarkably, that the upstream is 3 Mbit/s lower than the downstream.

Does this help you? Do you need some more data? Feel free to ask!


>
>> rt61pci (original (unpatched) from OpenSuSE 11.3)
>> ==============================================
>>
>> download
>> 0,7 MBit/s
>>
>> upstream
>> error (interrupted system call)
>>
>>
>> If you compare ndiswrapper with rt61pci patched, there is a difference
>> of about 6 MBits/s. The unpatched version can't be used at all.
>
> Ok, so either the txpower handling in rt61pci needs to be reviewed or your
> eeprom contents are crippled up. Not sure though ...

Is there a way to check this? Can I do anything to test?


Kind regards,
Andreas
