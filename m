Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166Ab0GGVzr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 17:55:47 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36970 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756716Ab0GGVzq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 17:55:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=dV+Qp6Hlxj2OCSkpYnAqc+Hmny18IAYoo8RHqaVTxGt0s27xIyOKJtFZAAa6VKeVF7
         /Z3q2i0UypzUMw8zAkdcBKUJ6hK1lrlUXc8dsrF4uMnPN/PsUecrTUAVNryNQyj/rY80
         cgAvNmdwVe36gin3kY2uRQ27O7bU1aG7BrrEg=
MIME-Version: 1.0
In-Reply-To: <1278538820-1392-17-git-send-email-arnd@arndb.de>
References: <1278538820-1392-1-git-send-email-arnd@arndb.de> 
	<1278538820-1392-17-git-send-email-arnd@arndb.de>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 7 Jul 2010 17:55:25 -0400
Message-ID: <AANLkTilxcVzDv-BSPz6ZaDDyWx7j8_HFU4hIEaf6KHOC@mail.gmail.com>
Subject: Re: [PATCH 16/18] llseek: automatically add .llseek fop
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, John Kacur <jkacur@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christoph Hellwig <hch@lst.de>, Julia Lawall <julia@diku.dk>,
       Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 7, 2010 at 17:40, Arnd Bergmann wrote:
> All file_operations should get a .llseek
> operation so we can make nonseekable_open
> the default for future file operations
> without a .llseek pointer.
>
> The three cases that we can automatically
> detect are no_llseek, seq_lseek and
> default_llseek. For cases where we can
> we can automatically prove that the
> file offset is always ignored, we use
> noop_llseek, which maintains the current
> behavior of not returning an error from
> a seek.
>
> New drivers should normally not use
> noop_llseek but instead use no_llseek and
> call nonseekable_open at open time.
> Existing drivers can be converted to do
> the same when the maintainer knows for
> certain that no user code relies on calling
> seek on the device file.

can we skip the transition for devices that we already know ?

> --- a/arch/blackfin/kernel/kgdb_test.c
> +++ b/arch/blackfin/kernel/kgdb_test.c
> static const struct file_operations kgdb_test_proc_fops = {
> +       .llseek = noop_llseek,/* read and write both use no f_pos */
> --- a/arch/blackfin/mach-bf561/coreb.c
> +++ b/arch/blackfin/mach-bf561/coreb.c
>  static const struct file_operations coreb_fops = {
> +       .llseek = noop_llseek,/* no read or write fn */

neither of these drivers are seekable, so attempts to do so should be
an error ...

> drivers/char/bfin-otp.c
>+       .llseek = default_llseek,/* read accesses f_pos */

lseeking should work fine with bfin-otp, so this change is OK
-mike
