Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644Ab2C0N5W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 09:57:22 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:60716 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332Ab2C0N5U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 09:57:20 -0400
MIME-Version: 1.0
X-Originating-IP: [109.186.20.112]
In-Reply-To: <81C3A93C17462B4BBD7E272753C105792060C098E4@EXDCVYMBSTM005.EQ1STM.local>
References: <1323250088-1729-1-git-send-email-sjur.brandeland@stericsson.com>
 <201112091442.04294.arnd@arndb.de> <81C3A93C17462B4BBD7E272753C105792060B42C9C@EXDCVYMBSTM005.EQ1STM.local>
 <201203221657.09820.arnd@arndb.de> <81C3A93C17462B4BBD7E272753C105792060C098E4@EXDCVYMBSTM005.EQ1STM.local>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 27 Mar 2012 15:56:59 +0200
Message-ID: <CAK=WgbY+n_CESWCSiC5tAXTm+8CJVEd2TOa4H0-iVeeb1=3C9Q@mail.gmail.com>
Subject: Re: Using remoteproc with ST-Ericsson modem.
To: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "sjurbren@gmail.com" <sjurbren@gmail.com>,
        Loic PALLARDY <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sjur,

On Tue, Mar 27, 2012 at 3:15 PM, Sjur BRENDELAND
<sjur.brandeland@stericsson.com> wrote:
> However, we have a couple of requirements that are different.
> - We don't use a ELF binary for resource definition. We have resource
>  definitions in a binary format outside the binary. (I'm afraid I'm
>  not able to change this).

That's ok:

We coupled the resource table with the firmware binary in order to
reflect the strong ties it has with the firmware's software and to
prevent issues of loading the wrong table with a given firmware, but
supporting an external resource table will help others as well so it's
definitely in the plans (feel free to take a stab at it if you want).

> In order to use remoteproc, I think it could be a good idea to make the
> firmware, resource and possible Virtio handling pluggable. E.g:
>
> static struct rproc_ops rproc_ops = {
>      ...
>       .fw_sanity_check = fw_sanity_check,
>       .fw_resource_handler = fw_resource_handler,
>       .fw_load = fw_load,
>       .fw_config_virtio = fw_config_virtio,
> };

Can you please elaborate why would you want that ? Let's go
requirement by requirement.

I strongly prefer to extend the generic code to support additional
requirements rather than to allow platform-specific implementations to
override it (the motivation is to prevent code duplication).

> I think we need to be able to launch other Virtio device types than
> VIRTIO_ID_RPMSG as well.

Sure. Please note that we already support that today: a firmware can
indicate any type of (and number of) virito devices it supports, and
remoteproc will create those device as needed.

> Most likely, I need to make a CAIF specific
> VIRTIO type

Have you considered making this an rpmsg driver ? it might make your
implementation simpler.

> due to the fact that I need RX direction to be reversed
> (modem must be able to post it's payload buffer to Virtio ring).

It sounds like something that Loic and Ludovic (cc'ed) have been
dealing with recently too. To solve it, they have created a symmetric
variation of vrings - you might want to take a look at their
implementation.

> We also define stream channels. As mentioned, I'm considering the possibility
> of reusing Virtio console.

Sounds nice. We tried virtio console with a remote processor and it
worked quite nicely (there're still a few details that need some work
in that front, mainly if your rproc is behind an IOMMU, but otherwise
it should be quite smooth).

Thanks,
Ohad.
