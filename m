Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab1D0I3u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 04:29:50 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:65433 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654Ab1D0I3r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 04:29:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=f6YfG091lb7VD31yrvJeplQEH0caO/E9JPkaW2Gt0Y+F8pQaVeLxzvtVs1vxvvRap8
         MLEkABbug8f+m+82x7IcBe4RnOBSCzgrVfShwyUsP7RiMAsjcX0WmRgBiyKoMUasVMQ7
         fL+ll2Lc+9PqmuDjNh5mK4pc20FTo94PMNj4I=
MIME-Version: 1.0
In-Reply-To: <1303847902.18763.38.camel@gandalf.stny.rr.com>
References: <ae304c124297e5ca75721398f398f6d524b615d2.1303843697.git.tfransosi@gmail.com>
	<20110426190531.GA4556@p183>
	<1303845468.18763.32.camel@gandalf.stny.rr.com>
	<20110426192029.GA4686@p183>
	<BANLkTinxvyxSK9f+kkQugNkQEBf1O65bLQ@mail.gmail.com>
	<1303846642.18763.37.camel@gandalf.stny.rr.com>
	<1303847110.24299.50.camel@Joe-Laptop>
	<BANLkTimf44AgMAViHrSEz78ifHUYb8ji6g@mail.gmail.com>
	<1303847902.18763.38.camel@gandalf.stny.rr.com>
Date: Wed, 27 Apr 2011 10:29:46 +0200
Message-ID: <BANLkTike-s90heETJsZ+z7Kim8f-hN=UPw@mail.gmail.com>
Subject: Re: [PATCH] linux/string.h: Introduce streq macro.
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thiago Farina <tfransosi@gmail.com>, Joe Perches <joe@perches.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 9:58 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Tue, 2011-04-26 at 16:47 -0300, Thiago Farina wrote:
>
>> > $ grep -rP --include=*.[ch] "\bstrcmp.*==\s*0\b" * | wc -l
>> > 1143
>> > $ grep -rP --include=*.[ch] "\!\s*strcmp\s*\(" *  | wc -l
>> > 1663
>> >
>> > Can you count how many misuses of strcmp have been
>> > corrected?
>>
>> > Do you plan to convert the existing 2800?
>>
>> I'd work on this without any problem.
>
> Nothing a perl script can't do either.

If you are really going to do that, please use a coccinelle's semantic
patch (which is designed precisely for that purpose) and document it
so that it can be included in the standard set of semantic patches
applied to the kernel regularly, i.e. something like:

@@ expression E1, E2; @@
- strcmp(E1,E2) == 0
+ streq(E1,E2)

@@ expression E1, E2; @@
- strcmp(E1,E2) != 0
+ !streq(E1,E2)

@@ expression E1, E2; @@
- !strcmp(E1,E2)
+ streq(E1,E2)

@@ expression E1, E2; @@
- strcmp(E1,E2)
+ !streq(E1,E2)

This produces a patch ~1.1 MB in size, which is probably going to
produce some headaches when merging other patches...

$ diffstat streq.patch | tail -1
 1073 files changed, 3429 insertions(+), 3419 deletions(-)

$ diffstat streq.patch | sort -nk 3 | tail -20
 drivers/sbus/char/envctrl.c                                     |   30 -
 fs/reiserfs/bitmap.c                                            |   30 -
 sound/pci/hda/hda_eld.c                                         |   30 -
 drivers/video/matrox/matroxfb_base.c                            |   32 -
 arch/blackfin/kernel/module.c                                   |   34 +-
 tools/perf/util/symbol.c                                        |   35 +-
 scripts/mod/modpost.c                                           |   38 +-
 net/irda/irlan/irlan_client.c                                   |   40 +-
 drivers/staging/hv/vmbus_drv.c                                  |   42 +-
 drivers/usb/gadget/gadget_chips.h                               |   42 +-
 drivers/s390/net/qeth_l3_sys.c                                  |   44 +-
 drivers/macintosh/windfarm_smu_controls.c                       |   48 +-
 security/selinux/hooks.c                                        |   48 +-
 security/smack/smack_lsm.c                                      |   48 +-
 arch/x86/pci/common.c                                           |   50 +--
 drivers/net/niu.c                                               |   54 +--
 fs/xfs/linux-2.6/xfs_super.c                                    |   92 ++---
 tools/perf/util/trace-event-parse.c                             |  108 +++---
 drivers/staging/wlags49_h2/wl_profile.c                         |  121 +++----
 net/core/pktgen.c                                               |
164 +++++-----

Miguel Ojeda

>
> -- Steve
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
