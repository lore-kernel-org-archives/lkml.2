Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529Ab1ANDP7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 22:15:59 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43383 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab1ANDPx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 22:15:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=tk2VWDO6ZouCnz/xgu7X2NlDgLxrFXh9PBjv7DzKmVg4khy5AsPNWhI6K1X25hLJ24
         CIBq7jsezlK1MNhYskakhrlbZ6Gcyd2ig+OwD8zTxgatkDI473HtnKGA9oy/XHeDJClI
         glvW6tDpBncPrXBKrcLEIka2jUdVAE9N8Mk0E=
MIME-Version: 1.0
In-Reply-To: <AANLkTilcEZDsWTWBjrXIgiIaBPWZN5k-RMhFE6VvVlhc@mail.gmail.com>
References: <AANLkTikmFJAHEBwAZ_lPosAZH3JO2zA5KetXuHvfe4WT@mail.gmail.com> <AANLkTilcEZDsWTWBjrXIgiIaBPWZN5k-RMhFE6VvVlhc@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 13 Jan 2011 19:15:32 -0800
Message-ID: <AANLkTikcKM4jAVRdrWHcgG4ED604meekbLj06qYUwjGC@mail.gmail.com>
Subject: Re: Linux script to enable ASPM / Documentation for ASPM
To: linux-kernel@vger.kernel.org
Cc: linux-wireless <linux-wireless@vger.kernel.org>, Martin Mares <mj@ucw.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 4:02 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Mon, Jun 21, 2010 at 3:58 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> ASPM was a dark magic when I first started looking at it. Some of it
>> is still dark but what I was able to understand with the help of
>> colleagues at work I've managed to stash here for now:
>>
>> http://wireless.kernel.org/en/users/Documentation/ASPM
>>
>> Then enabling ASPM was also quite a challenge and I always had to go
>> back and revisit the procedures, so to help with that instead I wrote
>> a script to do this for you correctly:
>>
>> http://kernel.org/pub/linux/kernel/people/mcgrof/aspm/enable-aspm
>>
>> Its sha1sum is: f5804fdab512065f219e55addf78c6654f1fc045
>>
>> If any of that looks confusing refer to the documentation above.
>>
>> There's a TODO there, so I'll get to the different items when I can
>> but if you like feel free to send me patches as well:
>>
>>  TODO: patches are welcomed to me until we submit to to
>>       PCI Utilities upstream.
>>
>>  This can be improved by in this order:
>>
>>        * Accept arguments for endpoint and root complex address, and
>>          desired ASPM settings
>>        * Look for your ASPM capabilities by quering your
>>          LnkCap register first. Use these values to let you
>>          select whether you want to enable only L1 or L1 & L0s
>>        * Searching for your root complex for you
>>        * Search for your PCI device by using the driver
>>        * Disable your driver and ask to reboot ?
>>        * Rewrite in C
>>        * Write ncurses interface [ wishlist ]
>>        * Write GTK/QT interface [ wishlist ]
>>        * Submit upstream as aspm.c to the PCI Utilities, which are
>>          maintained by Martin Mares <mj@ucw.cz>
>
> Come to think of it, would this be welcomed upstream in the PCI utils
> as is for now?

New version that'll work with new setpci.

http://kernel.org/pub/linux/kernel/people/mcgrof/aspm/enable-aspm
sha1sum:
f2e6e9a36ff7fe3b875229ee237f605d0695b18a

with this diff:

--- enable-aspm.old	2011-01-14 03:13:33.248428802 +0000
+++ enable-aspm	2011-01-14 03:12:51.711354522 +0000
@@ -161,11 +161,11 @@
 		exit
 	fi

-	SEARCH=$(setpci -s $1 34)
+	SEARCH=$(setpci -s $1 34.b)
 	# We know on the first search $SEARCH will not be
 	# 10 but this simplifies the implementation.
 	while [[ $SEARCH != 10 && $SEARCH_COUNT -le $MAX_SEARCH ]]; do
-		END_SEARCH=$(setpci -s $1 $SEARCH)
+		END_SEARCH=$(setpci -s $1 ${SEARCH}.b)

 		# Convert hex digits to uppercase for bc
 		SEARCH_UPPER=$(printf "%X" 0x${SEARCH})
@@ -176,7 +176,7 @@
 		fi

 		SEARCH=$(echo "obase=16; ibase=16; $SEARCH + 1" | bc)
-		SEARCH=$(setpci -s $1 $SEARCH)
+		SEARCH=$(setpci -s $1 ${SEARCH}.b)

 		let SEARCH_COUNT=$SEARCH_COUNT+1
 	done
@@ -200,7 +200,7 @@
 		return 1
 	fi

-	ASPM_BYTE_HEX=$(setpci -s $1 $ASPM_BYTE_ADDRESS)
+	ASPM_BYTE_HEX=$(setpci -s $1 ${ASPM_BYTE_ADDRESS}.b)
 	ASPM_BYTE_HEX=$(printf "%X" 0x${ASPM_BYTE_HEX})
 	# setpci doesn't support a mask on the query yet, only on the set,
 	# so to verify a setting on a mask we have no other optoin but
@@ -228,11 +228,11 @@
 	fi

 	# This only writes the last 3 bits
-	setpci -s $1 ${ASPM_BYTE_ADDRESS}=${ASPM_SETTING}:3
+	setpci -s $1 ${ASPM_BYTE_ADDRESS}.b=${ASPM_SETTING}:3

 	sleep 3

-	ACTUAL_ASPM_BYTE_HEX=$(setpci -s $1 ${ASPM_BYTE_ADDRESS})
+	ACTUAL_ASPM_BYTE_HEX=$(setpci -s $1 ${ASPM_BYTE_ADDRESS}.b)
 	ACTUAL_ASPM_BYTE_HEX=$(printf "%X" 0x${ACTUAL_ASPM_BYTE_HEX})

 	# Do not retry this if it failed, if it failed to set.
