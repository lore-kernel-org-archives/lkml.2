Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057Ab2BSHv2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 02:51:28 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48839 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444Ab2BSHv1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 02:51:27 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dhillf@gmail.com designates 10.52.28.167 as permitted sender) smtp.mail=dhillf@gmail.com; dkim=pass header.i=dhillf@gmail.com
MIME-Version: 1.0
In-Reply-To: <1329636505-13651-1-git-send-email-sboyd@codeaurora.org>
References: <1329636505-13651-1-git-send-email-sboyd@codeaurora.org>
Date: Sun, 19 Feb 2012 15:51:26 +0800
Message-ID: <CAJd=RBCxegSkWwDGbyj1tnpp_-xwSBbi9gw-wE79++hnpiC=jA@mail.gmail.com>
Subject: Re: [PATCH] regulator: Fix and simplify debugfs support
From: Hillf Danton <dhillf@gmail.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 19, 2012 at 3:28 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> If CONFIG_DEBUG_FS=y debugfs functions will never return an
> ERR_PTR. Instead they'll return NULL. The intent is to remove
> ifdefs in calling code.
>

Unfortunately there is no decrement in #ifdefs observed:(

> Instead of checking for an ERR_PTR check for NULL. This simplifies
> the code and also fixes an error check that would never have
> worked otherwise. While we're here modernize the code to use
> S_IRUGO instead of 0444.
>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>
> If we're willing to sacrifice a pointer per rdev we can remove the
> ifdefs and the compiler should be able to optimize away the dead
> code.
>
>  drivers/regulator/core.c |   15 +++++----------
>  1 file changed, 5 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
> index e9a83f8..f20696d 100644
> --- a/drivers/regulator/core.c
> +++ b/drivers/regulator/core.c
> @@ -1145,9 +1145,8 @@ static struct regulator *create_regulator(struct regulator_dev *rdev,
>  #ifdef CONFIG_DEBUG_FS
>        regulator->debugfs = debugfs_create_dir(regulator->supply_name,
>                                                rdev->debugfs);
> -       if (IS_ERR_OR_NULL(regulator->debugfs)) {
> +       if (!regulator->debugfs) {
>                rdev_warn(rdev, "Failed to create debugfs directory\n");
> -               regulator->debugfs = NULL;
>        } else {
>                debugfs_create_u32("uA_load", 0444, regulator->debugfs,
>                                   &regulator->uA_load);
> @@ -2712,9 +2711,8 @@ static void rdev_init_debugfs(struct regulator_dev *rdev)
>  {
>  #ifdef CONFIG_DEBUG_FS
>        rdev->debugfs = debugfs_create_dir(rdev_get_name(rdev), debugfs_root);
> -       if (IS_ERR(rdev->debugfs) || !rdev->debugfs) {
> +       if (!rdev->debugfs) {
>                rdev_warn(rdev, "Failed to create debugfs directory\n");
> -               rdev->debugfs = NULL;
>                return;
>        }
>
> @@ -3129,13 +3127,10 @@ static int __init regulator_init(void)
>
>  #ifdef CONFIG_DEBUG_FS
>        debugfs_root = debugfs_create_dir("regulator", NULL);
> -       if (IS_ERR(debugfs_root) || !debugfs_root) {
> +       if (!debugfs_root)
>                pr_warn("regulator: Failed to create debugfs directory\n");
> -               debugfs_root = NULL;
> -       }
> -
> -       if (IS_ERR(debugfs_create_file("supply_map", 0444, debugfs_root,
> -                                      NULL, &supply_map_fops)))
> +       else if (!debugfs_create_file("supply_map", S_IRUGO, debugfs_root,
> +                                      NULL, &supply_map_fops))
>                pr_warn("regulator: Failed to create supplies debugfs\n");
>  #endif
>
> --
> Sent by an employee of the Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
