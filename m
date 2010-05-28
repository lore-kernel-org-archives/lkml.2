Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab0E1TFb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 15:05:31 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63795 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635Ab0E1TF1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 15:05:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=Ba/7L2Vw4IB38GSn1YSBu1o5oxN1ncvT6P6PbUjhCL60Xrs+WRO/OFpI9fxTsvjUO8
         i0OBQcjz1yYkeZZT4Feu6rhuEDvjKdm32lynhEG86tLsqeWoricl79zRRZPQmrFu0nN/
         tQNNAUDUVh90IcOM5lPgOuL9gVVLYWo2nrgBo=
MIME-Version: 1.0
In-Reply-To: <AANLkTin8zU1enOG-SiAaHhdqtNtqW_L1qNGEA9oKFJxz@mail.gmail.com>
References: <AANLkTinUsKL0kqAjRG95xcrqjWPUlNn1TPD21wIJjShS@mail.gmail.com>
	<1275022651.2446.35.camel@edumazet-laptop>
	<AANLkTinROjXlrxl_vTAuTyAfj0bqPZiJJpBDa8lkc8IT@mail.gmail.com>
	<AANLkTin8zU1enOG-SiAaHhdqtNtqW_L1qNGEA9oKFJxz@mail.gmail.com>
Date: Fri, 28 May 2010 13:05:25 -0600
Message-ID: <AANLkTin5RRIrSwenr1wCuJlEvydVD9_d3U2ZLitSXigs@mail.gmail.com>
Subject: Re: Question about SIOCGIFCONF
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code in question is net-tools/lib/interface.c function
if_readproc() and associated routines.  Looks like a hole.

Jeff

On Fri, May 28, 2010 at 1:02 PM, Jeffrey Merkey <jeffmerkey@gmail.com> wrote:
> Review of the net-tools source code for IFCONFIG indicates that when
> /proc is not loaded and/or /proc/net/dev is not available, IFCONFIG
> will attempt to use this ioctl to determine which interfaces are
> present in the system.  Since the ioctl will not report unbound
> interfaces which are active, IFCONFIG will not properly report or
> detect network adapters which are unbound.  This seems to be a hole,
> although most of the time I assume /proc will always be mounted.
> Someone should review this and make a decision as to whether or not
> this could be a problem.  At any rate, it does not work as advertised.
>
> Jeff
>
> On Fri, May 28, 2010 at 12:31 PM, Jeffrey Merkey <jeffmerkey@gmail.com> wrote:
>> Actually,  I verified last night it only returns interfaces which have
>> been bound to an IP address.  It does not return any interfaces which
>> are active but for which an IP address has not been bound.  So what I
>> said is accurate.  it's fucking busted.
>>
>> /proc/net/dev returns ALL interfaces.  this ioctl does not.
>>
>> Jeff
>>
>> On Thu, May 27, 2010 at 10:57 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>> Le jeudi 27 mai 2010 à 21:02 -0600, Jeffrey Merkey a écrit :
>>>> Why is SIOGICONF only instrumented to return a single interface lo for
>>>> example.  I noticed that ifconfig always uses /proc/net/dev but the
>>>> older SIOCGIFCONF ioctl seems to be busted.  Anyone have an
>>>> explanation or is this just how the shit is these days or is the
>>>> fucking thing broken (seems to be). ?
>>>
>>> Shit comes from you eyes maybe ?
>>>
>>> Correction : Shit comes from your eyes, definitely.
>>>
>>> Proof :
>>>
>>> # strace -o /tmp/STRACE ifconfig -a
>>> # grep SIOCGIFCONF /tmp/STRACE
>>> ioctl(4, SIOCGIFCONF, {120, {{"lo", {AF_INET, inet_addr("127.0.0.1")}},
>>> {"wlan0", {AF_INET, inet_addr("192.168.1.21")}}, {"ppp0", {AF_INET,
>>> inet_addr("10.150.51.210")}}}}) = 0
>>>
>>>
>>> Part of ifconfig :
>>>
>>>    ifc.ifc_buf = NULL;
>>>    for (;;) {
>>>        ifc.ifc_len = sizeof(struct ifreq) * numreqs;
>>>        ifc.ifc_buf = xrealloc(ifc.ifc_buf, ifc.ifc_len);
>>>
>>>        if (ioctl(skfd, SIOCGIFCONF, &ifc) < 0) {
>>>            perror("SIOCGIFCONF");
>>>            goto out;
>>>        }
>>>        if (ifc.ifc_len == sizeof(struct ifreq) * numreqs) {
>>>            /* assume it overflowed and try again */
>>>            numreqs += 10;
>>>            continue;
>>>        }
>>>        break;
>>>    }
>>>
>>> maybe numreqs should be firt initialized to 64, then doubled each
>>> round...
>>>
>>>
>>>
>>
>
