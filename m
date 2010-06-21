Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616Ab0FUHXN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 03:23:13 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:52341 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428Ab0FUHXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 03:23:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=AMR/qcyarm6r1kPYefK/bqmNhOG7km+sQiML3PZe6kHo1g889VlbFM7L5ySeQNzwUY
         OW5wIn8zBXcxJIevE70rh2yPAmXRDOKwEsFlTQnOeovQlcGXkUHE+XQm3kXf/zppXcR/
         1fCHUNnnHfn/k03vtg/xU9TcXakK8u5rWk7k4=
MIME-Version: 1.0
In-Reply-To: <20100621071551.GA16109@oksana.dev.rtsoft.ru>
References: <20090818214449.GA12848@oksana.dev.rtsoft.ru> <20090818214622.GA22651@oksana.dev.rtsoft.ru> 
	<AANLkTikg60s6ZRSEDCq9PQK1z7hJtBDk6t4VE1lYDv8u@mail.gmail.com> 
	<20100618133212.GA5276@oksana.dev.rtsoft.ru> <0F1B54C89D5F954D8535DB252AF412FA065551D8@chinexm1.ad.analog.com> 
	<AANLkTiksYofs6hhWta6uFX2cla_g8pBu0Mtbtcbv-2tl@mail.gmail.com> 
	<20100621071551.GA16109@oksana.dev.rtsoft.ru>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 21 Jun 2010 15:22:48 +0800
Message-ID: <AANLkTiknH95loHJsQNxvCCyQbriCFWqM5LHl3wKzmdWX@mail.gmail.com>
Subject: Re: [Uclinux-dist-devel] [PATCH 1/2] mtd: m25p80: Reworkprobing/JEDEC 
	code
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: "Song, Barry" <Barry.Song@analog.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Artem Bityutskiy <dedekind1@gmail.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, linux-mtd@lists.infradead.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o5L7NPim025273

On Mon, Jun 21, 2010 at 3:15 PM, Anton Vorontsov <cbouatmailru@gmail.com> wrote:> On Mon, Jun 21, 2010 at 11:27:31AM +0800, Barry Song wrote:> [...]>> > How about we add a non_jedec flag in platform_data, if the flag is 1, we>> > let the detection pass even though the ID is 0? Otherwise, we need a>> > valid ID?>> Here i mean:>> This will break at least OF-enabled platforms (e.g. PowerPC),> they assume that the driver will success for non-JEDEC flashes.> OF platforms don't pass platform data, and even if they did,> device tree doesn't specify if the flash is JEDEC or non-JEDEC.>> Which is why I think that, by default, the driver should> successfully register the flash even if JEDEC probe fails. So,> instead of checking for "!non_jedec", I would recommend> "force_jedec" check.
Mike Frysinger suggested to use non_jedec since most devices arestandard jedec devices. Only if non_jedec=1, we let the detection passif ID is 0.
>>> Index: drivers/mtd/devices/m25p80.c>> ===================================================================>> --- drivers/mtd/devices/m25p80.c Â  Â  Â (revision 8927)>> +++ drivers/mtd/devices/m25p80.c Â  Â  Â (revision 8929)>> @@ -795,8 +795,13 @@>>>> Â  Â  Â  Â  Â  Â  Â  jid = jedec_probe(spi);>> Â  Â  Â  Â  Â  Â  Â  if (!jid) {>> - Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  dev_info(&spi->dev, "non-JEDEC variant of %s\n",>> - Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â id->name);>> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  if (!data->non_jedec) {>> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  dev_err(&spi->dev, "fail to detect%s\n",>> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  id->name);>> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  return -ENODEV;>> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  } else>> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  dev_info(&spi->dev, "non-JEDEC variant of %s\n",>> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  id->name);>> Â  Â  Â  Â  Â  Â  Â  } else if (jid != id) {>> --> Anton Vorontsov> email: cbouatmailru@gmail.com> irc://irc.freenode.net/bd2>ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
