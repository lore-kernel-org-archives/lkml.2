Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557Ab2AYV44 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 16:56:56 -0500
Received: from hades.mikemestnik.net ([184.106.158.151]:59730 "EHLO
	hades.mikemestnik.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab2AYV4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 16:56:55 -0500
Message-ID: <4F207AA5.2080309@mikemestnik.net>
Date: Wed, 25 Jan 2012 15:56:53 -0600
From: Mike Mestnik <cheako@mikemestnik.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0) Gecko/20111223 Thunderbird/10.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Tiered swap for zram.
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zram is great, but it can fill up easily and when it does new/fresh
pages get pushed out to disk swap.  I've written a small bash script
that will flush zram swap to disk every five min.  However this is
better done with the VM subsystem and I suggest that swap mounts have a
tier as well as the current priority.

( while sleep 300; do for ech in /dev/zram?; do swapoff $ech& done; for
ech in /dev/zram?; do wait; done; for ech in /dev/zram?; do swapon -p 5
$ech& done; done; )& disown

The idea is that after a page has been in swap tier X for, say five min,
it will graduate to swap tier Y.  This keeps swap tier X free from any
long standing pages that are just taking up valuable realestate.

This script seams to do what I'm asking for, but at a heavy cost.



My second suggestion may take a while longer to implement.  It involves
adding a new bit-field to the record for each page.  This bitfield would
indicate the compression level/type of the contents of a page.  For
example zram would set the bit corresponding to the compresion it's
configured to use.

This would allow zram to refuse requests to swap pages that are already
compressed.  Thus further allow it to swap it's self.  When a swap mount
refuses a page this would be equivalent to that swap space being full
and the next swap mount would be used.

Future advancements of this bit-field may indicate the contents of
userspace pages, zram and others can mark a page as not vary well
compressible.  As such it's clear that this bit-field should be cleared
or marked dirty if the page is ever written to.

Thank you for a few moments of your time.  I hope that these could be
implemented.

