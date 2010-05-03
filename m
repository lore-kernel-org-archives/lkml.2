Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab0ECRHi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 13:07:38 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:42691 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729Ab0ECRHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 13:07:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Y6ttDq8fP8a6EcJ4YEmWF3WJgFIRhBA+nVe1E8/yUNvIfUR+nBqW30ZM7GravTUBOx
         j9k7SKFhdObL4ks7zj0cz3llpeQgXejZchumkRwOkgdttMvP/ZqciQU5XRF2F3D2zL2l
         SsPLpaviKp5xHM1Cn+AWL+I7lqH5ZhGL3SvP0=
Message-ID: <4BDF0253.6030302@gmail.com>
Date: Mon, 03 May 2010 19:05:23 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Samo Pogacnik <samo_pogacnik@t-2.net>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] console logging detour via printk
References: <1272664980.10241.77.camel@itpsd6lap>	 <20100501120418.6fca2aad@lxorguk.ukuu.org.uk>	 <1272739689.2147.156.camel@itpsd6lap>  <4BDD4CD7.2060205@gmail.com> <1272806987.2155.34.camel@itpsd6lap>
In-Reply-To: <1272806987.2155.34.camel@itpsd6lap>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 02/05/2010 15:29, Samo Pogacnik ha scritto:
> Dne 02.05.2010 (ned) ob 11:58 +0200 je Marco Stornelli zapisal(a):
>> 01/05/2010 20:48, Samo Pogacnik wrote:
>>
>> Mmm...It's an interesting problem. I see in my distro (openSuse) a
>> script called boot.klog that it seems to perform that (even initrd
>> part). In the file boot.msg I can see the initial prints of the kernel
>> and user space scripts.
>>
> Thanks for the info. 
> Is this boot.klog script from the initrd image or from the real rootfs?
> As you can see, i am still suspicious about the initrd part user console
> messages:)
> 
> Samo
> 
> 

In the initrd there's the script blogd.sh:

if test -z "$fboot" -a -z "$quiet" -a -z "$REDIRECT" ; then
    REDIRECT=$(showconsole 2>/dev/null)
    if test -n "$REDIRECT" ; then
	if test "$devpts" != "yes" ; then
	    mount -t devpts devpts /dev/pts
	    devpts=yes
	fi
	> /dev/shm/initrd.msg
	ln -sf /dev/shm/initrd.msg /var/log/boot.msg
	mkdir -p /var/run
	/sbin/blogd $REDIRECT
    fi
fi

And in the rootfs the boot.klog script:

# Read all kernel messages generated until now and put them in one file.
    test -s /var/log/boot.msg && mv -f /var/log/boot.msg /var/log/boot.omsg
    echo Creating /var/log/boot.msg
    if test -x /sbin/klogd ; then
        # klogd syncs out the file
	/sbin/klogd -s -o -n -f /var/log/boot.msg
	test -s /var/log/boot.msg
	rc_status -v1 -r
    elif test -x /bin/dmesg ; then
	/bin/dmesg > /var/log/boot.msg
	/bin/sync
	test -s /var/log/boot.msg
	rc_status -v1 -r
    fi
    if test -e /dev/shm/initrd.msg ; then
	cat /dev/shm/initrd.msg >> /var/log/boot.msg
	rm -f /dev/shm/initrd.msg
    fi
[ --- cut here --- ]

Regards,

Marco
