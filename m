Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab2IHS6W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 14:58:22 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65157 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102Ab2IHS6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 14:58:19 -0400
MIME-Version: 1.0
In-Reply-To: <1347112918-7738-1-git-send-email-peter.senna@gmail.com>
References: <1347112918-7738-1-git-send-email-peter.senna@gmail.com>
Date: Sat, 8 Sep 2012 15:58:18 -0300
Message-ID: <CALF0-+U_D4ipSbN=DHSdxRvE1sju-Uq0e_mTE9=QsjLOtpLe1w@mail.gmail.com>
Subject: Re: [PATCH v2] drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c:
 fix error return code
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        kernel-janitors@vger.kernel.org, wharms@bfs.de, Julia.Lawall@lip6.fr,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

On Sat, Sep 8, 2012 at 11:01 AM, Peter Senna Tschudin
<peter.senna@gmail.com> wrote:
> From: Peter Senna Tschudin <peter.senna@gmail.com>
>
> Convert a nonnegative error return code to a negative one, as returned
> elsewhere in the function.
>
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
>
> // <smpl>
> (
> if@p1 (\(ret < 0\|ret != 0\))
>  { ... return ret; }
> |
> ret@p1 = 0
> )
> ... when != ret = e1
>     when != &ret
> *if(...)
> {
>   ... when != ret = e2
>       when forall
>  return ret;
> }
>
> // </smpl>
>
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
>
> ---
> walter harms <wharms@bfs.de>, thanks for the tip. Please take a look carefully to check if I got your suggestion correctly. It was tested by compilation only.
>
>  drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c |   30 ++++++-----------
>  1 file changed, 12 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c b/drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c
> index c8c94fb..b663dac 100644
> --- a/drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c
> +++ b/drivers/media/pci/cx25821/cx25821-video-upstream-ch2.c
> @@ -704,11 +704,9 @@ int cx25821_vidupstream_init_ch2(struct cx25821_dev *dev, int channel_select,
>  {
>         struct sram_channel *sram_ch;
>         u32 tmp;
> -       int retval = 0;
>         int err = 0;
>         int data_frame_size = 0;
>         int risc_buffer_size = 0;
> -       int str_length = 0;
>
>         if (dev->_is_running_ch2) {
>                 pr_info("Video Channel is still running so return!\n");
> @@ -744,20 +742,16 @@ int cx25821_vidupstream_init_ch2(struct cx25821_dev *dev, int channel_select,
>         risc_buffer_size = dev->_isNTSC_ch2 ?
>                 NTSC_RISC_BUF_SIZE : PAL_RISC_BUF_SIZE;
>
> -       if (dev->input_filename_ch2) {
> -               str_length = strlen(dev->input_filename_ch2);
> -               dev->_filename_ch2 = kmemdup(dev->input_filename_ch2,
> -                                            str_length + 1, GFP_KERNEL);
> -
> -               if (!dev->_filename_ch2)
> -                       goto error;
> -       } else {
> -               str_length = strlen(dev->_defaultname_ch2);
> -               dev->_filename_ch2 = kmemdup(dev->_defaultname_ch2,
> -                                            str_length + 1, GFP_KERNEL);
> +       if (dev->input_filename_ch2)
> +               dev->_filename_ch2 = kstrdup(dev->input_filename_ch2,
> +                                                               GFP_KERNEL);
> +       else
> +               dev->_filename_ch2 = kstrdup(dev->_defaultname_ch2,
> +                                                               GFP_KERNEL);
>

You're replacing kmemdup for kstrdup, which is great,
but that's not anywhere in the commit message.

I'm not sure if you should re-send, but you should definitely
try to have better commit messages in the future!

Not to mention you're doing two things in one patch, and that makes
very difficult to bisect.

Thanks (and sorry for the nitpick)...
Ezequiel.
