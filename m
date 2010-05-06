Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab0EFSq3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 14:46:29 -0400
Received: from mail-yw0-f198.google.com ([209.85.211.198]:47781 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039Ab0EFSq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 14:46:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=AmIw4PuIioJbJSdNS73Yw9aD+fe0x2OjAjfXXT20wm0m7ik85NeK6ovlHhd/XnY6Ts
         ghn/DZRQOnI7/MUViCbxjm1AmSUXzl/EMbLIs0BEko4XTEIyyjGs05jPqwIN2Fr4kgxJ
         AGhR8OWfrg36UjCXyJum8ShltylMV2w/CDjrg=
MIME-Version: 1.0
In-Reply-To: <1273142265-11929-2-git-send-email-os@emlix.com>
References: <1273142265-11929-1-git-send-email-os@emlix.com> 
	<1273142265-11929-2-git-send-email-os@emlix.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 6 May 2010 14:46:04 -0400
Message-ID: <g2j8bd0f97a1005061146l2b01e45do15bf46162e38ce84@mail.gmail.com>
Subject: Re: [PATCH] ad7877: keep dma rx buffers in seperate cache lines
To: Oskar Schirmer <os@emlix.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       =?UTF-8?Q?Daniel_Gl=C3=B6ckner?= <dg@emlix.com>,
       Oliver Schneidewind <osw@emlix.com>, Johannes Weiner <jw@emlix.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o46InPaS002224

On Thu, May 6, 2010 at 06:37, Oskar Schirmer wrote:>  struct ser_req {> +       u16                     sample;> +       char                    __padalign[L1_CACHE_BYTES - sizeof(u16)];> +>        u16                     reset;>        u16                     ref_on;>        u16                     command;> -       u16                     sample;>        struct spi_message      msg;>        struct spi_transfer     xfer[6];>  };
are you sure this is necessary ?  ser_req is only ever used withspi_sync() and it's allocated/released on the fly, so how couldanything be reading that memory between the start of the transmissionand the return to adi7877 ?
>  struct ad7877 {> +       u16                     conversion_data[AD7877_NR_SENSE];> +       char                    __padalign[L1_CACHE_BYTES> +                                       - AD7877_NR_SENSE * sizeof(u16)];> +>        struct input_dev        *input;>        char                    phys[32];>> @@ -182,8 +188,6 @@ struct ad7877 {>        u8                      averaging;>        u8                      pen_down_acc_interval;>> -       u16                     conversion_data[AD7877_NR_SENSE];> ->        struct spi_transfer     xfer[AD7877_NR_SENSE + 2];>        struct spi_message      msg;
i can see the spi_message inside of this struct being a problembecause the spi transfer is doing asynchronously with spi_async().however, i would add a comment right above these two fields with ashort explanation as to why they're at the start and why the padexists so someone down the line doesnt move it.-mike���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
