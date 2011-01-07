Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115Ab1AGK5u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 05:57:50 -0500
Received: from mail-fx0-f66.google.com ([209.85.161.66]:56424 "EHLO
	mail-fx0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab1AGK5s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 05:57:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type:content-transfer-encoding;
        b=st+hN1aJ9V/bc+vylu10B7jK8LYoev3TsJ9hfNFqwVbriZYeb0djnK1zdXefX5DX/7
         NTTPhFA71JcylLC/cCBfdaC4XyM5sS3IviJQZyXfm9JPRCP9v+bwWYV4n4ZDPFwkgicF
         3Zvgttp0FGQ6cb51Ae2MIHTWcnQq0UA6yfdfI=
MIME-Version: 1.0
Date: Fri, 7 Jan 2011 11:57:45 +0100
X-Google-Sender-Auth: P4FdQrvC3vynFnO50VXXIANZWlM
Message-ID: <AANLkTinhrj38rbEt7ds971D9g-UF+xS0jmzO7X15ZaLn@mail.gmail.com>
Subject: [-next] ERROR: "strchr" [drivers/target/target_core_mod.ko] undefined!
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Nicholas Bellinger <nab@linux-iscsi.org>,
        James Bottomley <James.Bottomley@suse.de>
Cc: scsi <linux-scsi@vger.kernel.org>, Linux-Next <linux-next@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since a few days, linux-next shows:

| ERROR: "strchr" [drivers/target/target_core_mod.ko] undefined!

in m68k allmodconfig builds
(http://kisskb.ellerman.id.au/kisskb/buildresult/3754323/).

I guess this is caused by the following 3 calls to strstr():

drivers/target/target_core_configfs.c:
+       ptr = strstr(page, "1");

+       str = strstr(buf, "_");

+       str2 = strstr(str+1, "_");

Some versions of gcc replace calls to strstr() with single-character
"needle" string parameters by calls to strchr() behind our back.
This causes linking errors if strchr() is defined as an inline function
in <asm/string.h> (e.g. on m68k).

You can prevent this by explicitly calling strchr() instead.

Cfr. commit 59d309f9c8ef0bd01bf93cc0e758f1d810417bdb
("kgdb: Replace strstr() by strchr() for single-character needles).

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
