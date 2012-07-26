Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159Ab2GZNSo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 09:18:44 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63297 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab2GZNSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 09:18:43 -0400
MIME-Version: 1.0
In-Reply-To: <12201.1343215232@warthog.procyon.org.uk>
References: <20120720215636.14854.41208.stgit@warthog.procyon.org.uk>
 <CAHO5Pa0NOUk=Z8SNQ9t=Oi6aU96o-JtMuAytAoXJ2v1L0ntNww@mail.gmail.com>
 <28702.1343135952@warthog.procyon.org.uk> <CAHO5Pa310CYFKvyN4N21CHoCKJG-eJ04Q-yg1VmgwvgR5N91Rg@mail.gmail.com>
 <6193.1343211798@warthog.procyon.org.uk> <CAHO5Pa2ck_wqUwiuFUxEeU=k3dJvByyjpygpUhrSFRsMyBZ8Eg@mail.gmail.com>
 <12201.1343215232@warthog.procyon.org.uk>
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Thu, 26 Jul 2012 15:18:22 +0200
X-Google-Sender-Auth: Cklts3G6pJWzL-MBsfZRg0ZOkvg
Message-ID: <CAHO5Pa1rCV+Od4q3SVHbGf_08q1uAeaNZEHH6NEuouviOS0awA@mail.gmail.com>
Subject: Re: [PATCH 00/13] UAPI header file split
To: David Howells <dhowells@redhat.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de,
        tglx@linutronix.de, mingo@kernel.org, davej@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

I've not checked whether any of the below are fixed in the adjustments
that you made in the last 20 hours (though it looks like at least some
of them are not), but a little scripting to check the content of the
split files showed that while most of them were okay, in the cases
below, some comment text was being discarded by the scripts.

./include/linux/irqnr.h ./include/uapi/linux/irqnr.h
./arch/frv/include/asm/types.h ./arch/frv/include/uapi/asm/types.h
./arch/cris/include/asm/types.h ./arch/cris/include/uapi/asm/types.h
./arch/arm/include/asm/types.h ./arch/arm/include/uapi/asm/types.h
./arch/sh/include/asm/types.h ./arch/sh/include/uapi/asm/types.h
./arch/ia64/include/asm/kvm_para.h ./arch/ia64/include/uapi/asm/kvm_para.h
./arch/mn10300/include/asm/types.h ./arch/mn10300/include/uapi/asm/types.h
./arch/m68k/include/asm/types.h ./arch/m68k/include/uapi/asm/types.h
./arch/avr32/include/asm/types.h ./arch/avr32/include/uapi/asm/types.h
./arch/m32r/include/asm/types.h ./arch/m32r/include/uapi/asm/types.h

I found these using the script below, which tries to check the
integrity of the transformations you are making with your scripts.
Other than the files above, the results looked good.

Thanks,

Michael

=====
#!/bin/sh

# Set these two variables as appropriate

ORIG=$HOME/linux-pre-uapi                     # Tree before UAPI split
UDIR=$HOME/uapi/linux-headers     # Tree following UAPI split

cd $UDIR
for uapi in  $(find . -name '*.h' | grep uapi); do
    kapi=$(echo $uapi | sed 's%uapi/%%')
    if test -e $kapi; then
        r_kapi=$kapi
    else
        r_kapi=/dev/null
    fi

# Create "canonicalized versions" of input and output headers, by
# stripping out all lines starting with #, and sort to remove
# duplicated lines

    cat $uapi $r_kapi | grep -v '^#' | sort -u > /tmp/res.$$
    cat $ORIG/$kapi | grep -v '^#' | sort -u > /tmp/orig.$$

# Are there lines in one version of the "canonical"
# files, but not the other?

    comm -3 /tmp/res.$$ /tmp/orig.$$ > /tmp/cdiff.$$

    if test $(cat /tmp/cdiff.$$ | wc -l) -ne 0; then
        echo "========" $r_kapi $uapi
        cat /tmp/cdiff.$$
    fi
done



-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface", http://blog.man7.org/
