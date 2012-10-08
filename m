Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232Ab2JHW4G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 18:56:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40790 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568Ab2JHW4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 18:56:05 -0400
MIME-Version: 1.0
In-Reply-To: <1349456731-19977-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1349456731-19977-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Date: Tue, 9 Oct 2012 06:56:02 +0800
Message-ID: <CACVXFVOuQosgF+w6k1RH5D360J4pTM-N=quiSCc=GmWt0102rA@mail.gmail.com>
Subject: Re: [PATCH] firmware: Don't attempt to allocate zero bytes with vmalloc()
From: Ming Lei <ming.lei@canonical.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 6, 2012 at 1:05 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> vmalloc() will fail (very loudly) if we try to allocate zero bytes to
> read a zero byte file. Instead report that we successfully read in all
> zero bytes.
>
> It's not immediately obvious to me that this is better than returning an
> error but it seems better to punt the decision about that to the caller
> on the off chance that it's sensible.
>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/base/firmware_class.c |    5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index 8154145..a14eb92 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -62,6 +62,11 @@ static bool fw_read_file_contents(struct file *file, struct firmware *fw)
>         char *buf;
>
>         size = fw_file_size(file);
> +       if (size == 0) {
> +               fw->data = NULL;
> +               fw->size = 0;
> +               return true;
> +       }

Considered that zero-length firmware image doesn't make sense for drivers
(callers), maybe it is a insane firmware image, so how about treating it as a
failure?

Thanks,
--
Ming Lei
