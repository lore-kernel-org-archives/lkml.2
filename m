Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552Ab1GYWQH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 18:16:07 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:45882 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab1GYWQB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 18:16:01 -0400
MIME-Version: 1.0
In-Reply-To: <095a90240876c249ed33aa36f2543b54a0b68fc2.1311340371.git.andriy.shevchenko@linux.intel.com>
References: <095a90240876c249ed33aa36f2543b54a0b68fc2.1311340371.git.andriy.shevchenko@linux.intel.com>
Date: Tue, 26 Jul 2011 00:15:59 +0200
Message-ID: <CAJ0pr19UbhitnopWFyh19ADErn9=VQ6Gxank-Ntc1_O4rGBb-g@mail.gmail.com>
Subject: Re: [PATCH] mmc: mmc_test: avoid stalled file in debugfs
From: Per Forlin <per.forlin@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Ball <cjb@laptop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 July 2011 15:13, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> During card removal and inserting cycle the test file in the debugfs could be
> stalled until the host driver removes it. Let's keep the file in the linked
> list and destroy it when card is removed.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Thanks for catching and fixing this mistake. The two debugfs files
test and testlist were created but only testlist was added to the
list. This patch takes care of that and adds both test and testlist to
the linked list, and makes the code cleaner too.


> ---
>  drivers/mmc/card/mmc_test.c |   56 +++++++++++++++++++++++--------------------
>  1 files changed, 30 insertions(+), 26 deletions(-)
>
> diff --git a/drivers/mmc/card/mmc_test.c b/drivers/mmc/card/mmc_test.c
> index 006a5e9..915a221 100644
> --- a/drivers/mmc/card/mmc_test.c
> +++ b/drivers/mmc/card/mmc_test.c
> @@ -2900,7 +2900,7 @@ static const struct file_operations mmc_test_fops_testlist = {
>        .release        = single_release,
>  };
>
> -static void mmc_test_free_file_test(struct mmc_card *card)
> +static void mmc_test_free_dbgfs_file(struct mmc_card *card)
>  {
>        struct mmc_test_dbgfs_file *df, *dfs;
>
> @@ -2917,34 +2917,21 @@ static void mmc_test_free_file_test(struct mmc_card *card)
>        mutex_unlock(&mmc_test_lock);
>  }
>
> -static int mmc_test_register_file_test(struct mmc_card *card)
> +static int __mmc_test_register_dbgfs_file(struct mmc_card *card,
> +       const char *name, mode_t mode, const struct file_operations *fops)
>  {
>        struct dentry *file = NULL;
>        struct mmc_test_dbgfs_file *df;
> -       int ret = 0;
> -
> -       mutex_lock(&mmc_test_lock);
> -
> -       if (card->debugfs_root)
> -               file = debugfs_create_file("test", S_IWUSR | S_IRUGO,
> -                       card->debugfs_root, card, &mmc_test_fops_test);
> -
> -       if (IS_ERR_OR_NULL(file)) {
> -               dev_err(&card->dev,
> -                       "Can't create test. Perhaps debugfs is disabled.\n");
> -               ret = -ENODEV;
> -               goto err;
> -       }
>
>        if (card->debugfs_root)
> -               file = debugfs_create_file("testlist", S_IRUGO,
> -                       card->debugfs_root, card, &mmc_test_fops_testlist);
> +               file = debugfs_create_file(name, mode, card->debugfs_root,card,
> +                       fops);
Move card to next line together with fops and indent.
+               file = debugfs_create_file(name, mode, card->debugfs_root,
+                                                    card, fops);

>
>        if (IS_ERR_OR_NULL(file)) {
>                dev_err(&card->dev,
> -                       "Can't create testlist. Perhaps debugfs is disabled.\n");
> -               ret = -ENODEV;
> -               goto err;
> +                       "Can't create %s. Perhaps debugfs is disabled.\n",
> +                       name);
> +               return -ENODEV;
>        }
>
>        df = kmalloc(sizeof(struct mmc_test_dbgfs_file), GFP_KERNEL);
> @@ -2952,14 +2939,31 @@ static int mmc_test_register_file_test(struct mmc_card *card)
>                debugfs_remove(file);
>                dev_err(&card->dev,
>                        "Can't allocate memory for internal usage.\n");
> -               ret = -ENOMEM;
> -               goto err;
> +               return -ENOMEM;
>        }
>
>        df->card = card;
>        df->file = file;
>
>        list_add(&df->link, &mmc_test_file_test);
> +       return 0;
> +}
> +
> +static int mmc_test_register_dbgfs_file(struct mmc_card *card)
> +{
> +       int ret;
> +
> +       mutex_lock(&mmc_test_lock);
> +
> +       ret = __mmc_test_register_dbgfs_file(card, "test", S_IWUSR | S_IRUGO,
> +               &mmc_test_fops_test);
> +       if (ret)
> +               goto err;
> +
> +       ret = __mmc_test_register_dbgfs_file(card, "testlist", S_IRUGO,
> +               &mmc_test_fops_testlist);
> +       if (ret)
> +               goto err;
>
>  err:
>        mutex_unlock(&mmc_test_lock);
> @@ -2974,7 +2978,7 @@ static int mmc_test_probe(struct mmc_card *card)
>        if (!mmc_card_mmc(card) && !mmc_card_sd(card))
>                return -ENODEV;
>
> -       ret = mmc_test_register_file_test(card);
> +       ret = mmc_test_register_dbgfs_file(card);
>        if (ret)
>                return ret;
>
> @@ -2986,7 +2990,7 @@ static int mmc_test_probe(struct mmc_card *card)
>  static void mmc_test_remove(struct mmc_card *card)
>  {
>        mmc_test_free_result(card);
> -       mmc_test_free_file_test(card);
> +       mmc_test_free_dbgfs_file(card);
>  }
>
>  static struct mmc_driver mmc_driver = {
> @@ -3006,7 +3010,7 @@ static void __exit mmc_test_exit(void)
>  {
>        /* Clear stalled data if card is still plugged */
>        mmc_test_free_result(NULL);
> -       mmc_test_free_file_test(NULL);
> +       mmc_test_free_dbgfs_file(NULL);
>
>        mmc_unregister_driver(&mmc_driver);
>  }
> --
> 1.7.5.4
>
>

Acked-by: Per Forlin <per.forlin@linaro.org>

Thanks,
Per
