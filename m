Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab0E1SbH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 14:31:07 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49116 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627Ab0E1SbC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 14:31:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=kHcUU8zQeIjWQ7Bxx2gQ25LxHjWdhTmHTf4GVt770Xq0gsfcmTxZdhe1EtevMLzvho
         OhQWCsxG12LTkzAIAv4Oi+4FJSn7c2/+F37yIhWCY2RNLMLx0dKxg013WwxOzPftCwWf
         0qqExL5LXzIrKPeqgqdykUejYOKCXCtGxape8=
MIME-Version: 1.0
In-Reply-To: <1275022651.2446.35.camel@edumazet-laptop>
References: <AANLkTinUsKL0kqAjRG95xcrqjWPUlNn1TPD21wIJjShS@mail.gmail.com>
	<1275022651.2446.35.camel@edumazet-laptop>
Date: Fri, 28 May 2010 12:31:00 -0600
Message-ID: <AANLkTinROjXlrxl_vTAuTyAfj0bqPZiJJpBDa8lkc8IT@mail.gmail.com>
Subject: Re: Question about SIOCGIFCONF
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Actually,  I verified last night it only returns interfaces which have
been bound to an IP address.  It does not return any interfaces which
are active but for which an IP address has not been bound.  So what I
said is accurate.  it's fucking busted.

/proc/net/dev returns ALL interfaces.  this ioctl does not.

Jeff

On Thu, May 27, 2010 at 10:57 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le jeudi 27 mai 2010 à 21:02 -0600, Jeffrey Merkey a écrit :
>> Why is SIOGICONF only instrumented to return a single interface lo for
>> example.  I noticed that ifconfig always uses /proc/net/dev but the
>> older SIOCGIFCONF ioctl seems to be busted.  Anyone have an
>> explanation or is this just how the shit is these days or is the
>> fucking thing broken (seems to be). ?
>
> Shit comes from you eyes maybe ?
>
> Correction : Shit comes from your eyes, definitely.
>
> Proof :
>
> # strace -o /tmp/STRACE ifconfig -a
> # grep SIOCGIFCONF /tmp/STRACE
> ioctl(4, SIOCGIFCONF, {120, {{"lo", {AF_INET, inet_addr("127.0.0.1")}},
> {"wlan0", {AF_INET, inet_addr("192.168.1.21")}}, {"ppp0", {AF_INET,
> inet_addr("10.150.51.210")}}}}) = 0
>
>
> Part of ifconfig :
>
>    ifc.ifc_buf = NULL;
>    for (;;) {
>        ifc.ifc_len = sizeof(struct ifreq) * numreqs;
>        ifc.ifc_buf = xrealloc(ifc.ifc_buf, ifc.ifc_len);
>
>        if (ioctl(skfd, SIOCGIFCONF, &ifc) < 0) {
>            perror("SIOCGIFCONF");
>            goto out;
>        }
>        if (ifc.ifc_len == sizeof(struct ifreq) * numreqs) {
>            /* assume it overflowed and try again */
>            numreqs += 10;
>            continue;
>        }
>        break;
>    }
>
> maybe numreqs should be firt initialized to 64, then doubled each
> round...
>
>
>
