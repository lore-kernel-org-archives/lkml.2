Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096Ab0E1E5i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 00:57:38 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50868 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab0E1E5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 00:57:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=LXRI6JoLxcAaCNYOqvShc3I8KDiaT0B8D1WmOAqxoO66KdiMx+rTA/m0sPRLQJJkD3
         Txha8oRGE8ESqPZ60HCetpLtce3U2f94D4c29/v2/s+eSjTOZKyNpOXsAfMGzOgoAJpr
         pMUHzq6D8d2JeqDxp1kmfKFk0x8DLqA732jZE=
Subject: Re: Question about SIOCGIFCONF
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jeffrey Merkey <jeffmerkey@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTinUsKL0kqAjRG95xcrqjWPUlNn1TPD21wIJjShS@mail.gmail.com>
References: <AANLkTinUsKL0kqAjRG95xcrqjWPUlNn1TPD21wIJjShS@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 May 2010 06:57:31 +0200
Message-ID: <1275022651.2446.35.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 27 mai 2010 à 21:02 -0600, Jeffrey Merkey a écrit :
> Why is SIOGICONF only instrumented to return a single interface lo for
> example.  I noticed that ifconfig always uses /proc/net/dev but the
> older SIOCGIFCONF ioctl seems to be busted.  Anyone have an
> explanation or is this just how the shit is these days or is the
> fucking thing broken (seems to be). ?

Shit comes from you eyes maybe ?

Correction : Shit comes from your eyes, definitely.

Proof :

# strace -o /tmp/STRACE ifconfig -a
# grep SIOCGIFCONF /tmp/STRACE
ioctl(4, SIOCGIFCONF, {120, {{"lo", {AF_INET, inet_addr("127.0.0.1")}},
{"wlan0", {AF_INET, inet_addr("192.168.1.21")}}, {"ppp0", {AF_INET,
inet_addr("10.150.51.210")}}}}) = 0


Part of ifconfig :

    ifc.ifc_buf = NULL;
    for (;;) {
        ifc.ifc_len = sizeof(struct ifreq) * numreqs;
        ifc.ifc_buf = xrealloc(ifc.ifc_buf, ifc.ifc_len);

        if (ioctl(skfd, SIOCGIFCONF, &ifc) < 0) {
            perror("SIOCGIFCONF");
            goto out;
        }
        if (ifc.ifc_len == sizeof(struct ifreq) * numreqs) {
            /* assume it overflowed and try again */
            numreqs += 10;
            continue;
        }
        break;
    }

maybe numreqs should be firt initialized to 64, then doubled each
round...


