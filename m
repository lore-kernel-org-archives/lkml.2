Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061Ab0KDF7G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 01:59:06 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:60807 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863Ab0KDF7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 01:59:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:user-agent:date:message-id:mime-version
         :content-type;
        b=X305k+/EA7VMMsLjWnYLvKSbGN8KE403eoOtQrMiunuM8Gwx7idmBbRe/nwQJ5g3uW
         vM8SAq3xld7KI26Vuik1W6CNFyJT1XSF+cjyJwXAXI7aPJ4OLkm8mAgUVH24yrLlTi1C
         giyIzd11vWl8emrX4GcUO2pSWLCv1CAEwy41g=
From: Ben Gamari <bgamari.foss@gmail.com>
To: linux-kernel@vger.kernel.org, rsync@lists.samba.org, linux-mm@kvack.org
Subject: fadvise DONTNEED implementation (or lack thereof)
User-Agent: Notmuch/0.3.1-158-g04cd99c (http://notmuchmail.org) Emacs/23.1.1 (x86_64-pc-linux-gnu)
Date: Thu, 04 Nov 2010 01:58:58 -0400
Message-ID: <87lj597hp9.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've recently been trying to track down the root cause of my server's
persistent issue of thrashing horribly after being left inactive. It
seems that the issue is likely my nightly backup schedule (using rsync)
which traverses my entire 50GB home directory. I was surprised to find
that rsync does not use fadvise to notify the kernel of its use-once
data usage pattern.

It looks like a patch[1] was written (although never merged, it seems)
incorporating fadvise support, but I found its implementation rather
odd, using mincore() and FADV_DONTNEED to kick out only regions brought
in by rsync. It seemed to me the simpler and more appropriate solution
would be to simply flag every touched file with FADV_NOREUSE and let the
kernel manage automatically expelling used pages.

After looking deeper into the kernel implementation[2] of fadvise() the
reason for using DONTNEED became more apparant. It seems that the kernel
implements NOREUSE as a noop. A little googling revealed[3] that I not
the first person to encounter this limitation. It looks like a few
folks[4] have discussed addressing the issue in the past, but nothing
has happened as of 2.6.36. Are there plans to implement this
functionality in the near future? It seems like the utility of fadvise
is severely limited by lacking support for NOREUSE.

Cheers,

- Ben


[1] http://insights.oetiker.ch/linux/fadvise.html
[2] http://lxr.free-electrons.com/source/mm/fadvise.c?a=avr32
[3] https://issues.apache.org/jira/browse/CASSANDRA-1470
    http://chbits.blogspot.com/2010/06/lucene-and-fadvisemadvise.html
[4] http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg179576.html
    http://lkml.indiana.edu/hypermail/linux/kernel/0807.2/0442.html

