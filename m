Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111Ab2LMQ2K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 11:28:10 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:47391 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755502Ab2LMQ2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 11:28:07 -0500
MIME-Version: 1.0
In-Reply-To: <1355370586-6600-1-git-send-email-pgaikwad@nvidia.com>
References: <1355370586-6600-1-git-send-email-pgaikwad@nvidia.com>
From: Mike Turquette <mturquette@linaro.org>
Date: Thu, 13 Dec 2012 08:27:46 -0800
Message-ID: <CAPtuhThBigSQMkNDf16Fo1tddTKo=rPEydHmzep0DqtgLrB+HA@mail.gmail.com>
Subject: Re: [PATCH] clk: debug clock tree
To: Prashant Gaikwad <pgaikwad@nvidia.com>
Cc: swarren@nvidia.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 7:49 PM, Prashant Gaikwad <pgaikwad@nvidia.com> wrote:
> Adds debug file "clock_tree" in /sys/kernel/debug/clk dir.
> It helps to view all the clock registered in tree format.
>

Prashant,

Thanks for submitting this.  We've been talking about having a single
file for representing the tree for some time.

Regarding the output format had you considered using a well known
format which can be parsed using well known parsing libs?  This avoids
needing a custom parser just for this one file.  JSON springs to mind
as something lightweight and well-understood.

> For example:
>    clock                        enable_cnt  prepare_cnt  rate
> ---------------------------------------------------------------------
>  i2s0_sync                      0           0            24000000
>  spdif_in_sync                  0           0            24000000
>     spdif_mux                   0           0            24000000
>        spdif                    0           0            24000000
>           spdif_doubler         0           0            48000000
>              spdif_div          0           0            48000000
>                 spdif_2x        0           0            48000000
>  clk_32k                        2           2            32768
>     blink_override              1           1            32768
>        blink                    1           1            32768
>  clk_m                          2           2            12000000
>     clk_out_3_mux               0           0            12000000
>        clk_out_3                0           0            12000000
>     pll_ref                     3           3            12000000
>        pll_e_mux                0           0            12000000
>           pll_e                 0           0            100000000
>              cml0               0           0            100000000
>              cml1               0           0            100000000
>              pciex              0           0            100000000
>        pll_d2                   0           0            1000000
>           pll_d2_out0           0           0            500000
>        pll_d                    0           0            1000000
>           pll_d_out0            0           0            500000
>              dsib_mux           0           0            500000
>                 dsib            0           0            500000
>              dsia               0           0            500000
>
> Signed-off-by: Prashant Gaikwad <pgaikwad@nvidia.com>
> ---
>  drivers/clk/clk.c |   59 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 59 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index 56e4495e..7daf201 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -34,6 +34,59 @@ static struct dentry *rootdir;
>  static struct dentry *orphandir;
>  static int inited = 0;
>
> +static void clk_tree_show_one(struct seq_file *s, struct clk *c, int level)
> +{
> +       if (!c)
> +               return;
> +
> +       seq_printf(s, "%*s%-*s %-11d %-12d %-10lu",
> +                  level * 3 + 1, "",
> +                  30 - level * 3, c->name,
> +                  c->enable_count, c->prepare_count, c->rate);
> +       seq_printf(s, "\n");
> +}
> +
> +static void clk_tree_show_subtree(struct seq_file *s, struct clk *c, int level)
> +{
> +       struct clk *child;
> +       struct hlist_node *tmp;
> +
> +       if (!c)
> +               return;
> +
> +       clk_tree_show_one(s, c, level);
> +
> +       hlist_for_each_entry(child, tmp, &c->children, child_node)
> +               clk_tree_show_subtree(s, child, level + 1);
> +}
> +
> +static int clk_tree_show(struct seq_file *s, void *data)
> +{
> +       struct clk *c;
> +       struct hlist_node *tmp;
> +
> +       seq_printf(s, "   clock                        enable_cnt  prepare_cnt  rate\n");
> +       seq_printf(s, "---------------------------------------------------------------------\n");
> +

If we want this to be machine readable then we can probably drop the
heading and line of dashes altogether.

> +       hlist_for_each_entry(c, tmp, &clk_root_list, child_node)
> +               clk_tree_show_subtree(s, c, 0);
> +
> +       return 0;
> +}
> +
> +
> +static int clk_tree_open(struct inode *inode, struct file *file)
> +{
> +       return single_open(file, clk_tree_show, inode->i_private);
> +}
> +
> +static const struct file_operations clk_tree_fops = {
> +       .open           = clk_tree_open,
> +       .read           = seq_read,
> +       .llseek         = seq_lseek,
> +       .release        = single_release,
> +};
> +
>  /* caller must hold prepare_lock */
>  static int clk_debug_create_one(struct clk *clk, struct dentry *pdentry)
>  {
> @@ -167,12 +220,18 @@ static int __init clk_debug_init(void)
>  {
>         struct clk *clk;
>         struct hlist_node *tmp;
> +       struct dentry *d;
>
>         rootdir = debugfs_create_dir("clk", NULL);
>
>         if (!rootdir)
>                 return -ENOMEM;
>
> +       d = debugfs_create_file("clock_tree", S_IRUGO, rootdir, NULL,
> +                               &clk_tree_fops);

I prefer "clk_tree" versus "clock_tree".  If we only spell clock one
way then users won't have to spend as much time trying to remember
specific spellings of the word.

This also brings up the question of whether or not we should keep the
directory-based debugfs representation around.  I personally don't
care and I'm happy to deprecate it and remove at a future date if
others do not object.  However if you have some tooling based around
the existing clk debugfs stuff then please speak up and I'll keep both
around.

Thanks,
Mike

> +       if (!d)
> +               return -ENOMEM;
> +
>         orphandir = debugfs_create_dir("orphans", rootdir);
>
>         if (!orphandir)
> --
> 1.7.4.1
>
