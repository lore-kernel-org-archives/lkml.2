Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab2DFDpS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 23:45:18 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:64245 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752775Ab2DFDpQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 23:45:16 -0400
MIME-Version: 1.0
In-Reply-To: <1333576113-13196-2-git-send-email-swarren@wwwdotorg.org>
References: <1333576113-13196-1-git-send-email-swarren@wwwdotorg.org> <1333576113-13196-2-git-send-email-swarren@wwwdotorg.org>
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Thu, 5 Apr 2012 23:44:43 -0400
X-Google-Sender-Auth: p72e5sCqhwYwiMf1Kj8l_Z8ZoQA
Message-ID: <CAP=VYLpfssjmREbEcGMQ8P4N7wpKgv=vC++ho+UugtOsx5SxOQ@mail.gmail.com>
Subject: Re: [PATCH 2/6] regmap: allow regmap instances to be named
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        linux-next@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 4, 2012 at 5:48 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> From: Stephen Warren <swarren@nvidia.com>
>
> Some devices have multiple separate register regions. Logically, one
> regmap would be created per region. One issue that prevents this is that
> each instance will attempt to create the same debugfs files. Avoid this
> by allowing regmaps to be named, and use the name to construct the
> debugfs directory name.
>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
>  drivers/base/regmap/internal.h       |    3 ++-
>  drivers/base/regmap/regmap-debugfs.c |   14 +++++++++++---
>  drivers/base/regmap/regmap.c         |    4 ++--
>  include/linux/regmap.h               |    5 +++++
>  4 files changed, 20 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
> index 6ee4dc5..d9ea8f5 100644
> --- a/drivers/base/regmap/internal.h
> +++ b/drivers/base/regmap/internal.h
> @@ -47,6 +47,7 @@ struct regmap {
>
>  #ifdef CONFIG_DEBUG_FS
>        struct dentry *debugfs;
> +       const char *debugfs_name;
>  #endif
>
>        unsigned int max_register;
> @@ -110,7 +111,7 @@ int _regmap_write(struct regmap *map, unsigned int reg,
>
>  #ifdef CONFIG_DEBUG_FS
>  extern void regmap_debugfs_initcall(void);
> -extern void regmap_debugfs_init(struct regmap *map);
> +extern void regmap_debugfs_init(struct regmap *map, const char *name);

Hi Stephen,

Can you take a look at these linux-next fails?

drivers/base/regmap/regmap.c:349:2: error: too many arguments to
function 'regmap_debugfs_init'
drivers/base/regmap/regmap.c:434:2: error: too many arguments to
function 'regmap_debugfs_init'
make[4]: *** [drivers/base/regmap/regmap.o] Error 1

I'm assuming it is somehow related to the above commit (or family
of commits) -- since it complains about arg #s and you are changing
the arg #.  (I didn't bisect to 100% confirm this.)

http://kisskb.ellerman.id.au/kisskb/buildresult/6039717/
http://kisskb.ellerman.id.au/kisskb/buildresult/6040074/
http://kisskb.ellerman.id.au/kisskb/buildresult/6040070/


Thanks,
Paul.
>  extern void regmap_debugfs_exit(struct regmap *map);
>  #else
>  static inline void regmap_debugfs_initcall(void) { }
> diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
> index 251eb70..df97c93 100644
> --- a/drivers/base/regmap/regmap-debugfs.c
> +++ b/drivers/base/regmap/regmap-debugfs.c
> @@ -242,10 +242,17 @@ static const struct file_operations regmap_access_fops = {
>        .llseek = default_llseek,
>  };
>
> -void regmap_debugfs_init(struct regmap *map)
> +void regmap_debugfs_init(struct regmap *map, const char *name)
>  {
> -       map->debugfs = debugfs_create_dir(dev_name(map->dev),
> -                                         regmap_debugfs_root);
> +       if (name) {
> +               map->debugfs_name = kasprintf(GFP_KERNEL, "%s-%s",
> +                                             dev_name(map->dev), name);
> +               name = map->debugfs_name;
> +       } else {
> +               name = dev_name(map->dev);
> +       }
> +
> +       map->debugfs = debugfs_create_dir(name, regmap_debugfs_root);
>        if (!map->debugfs) {
>                dev_warn(map->dev, "Failed to create debugfs directory\n");
>                return;
> @@ -274,6 +281,7 @@ void regmap_debugfs_init(struct regmap *map)
>  void regmap_debugfs_exit(struct regmap *map)
>  {
>        debugfs_remove_recursive(map->debugfs);
> +       kfree(map->debugfs_name);
>  }
>
>  void regmap_debugfs_initcall(void)
> diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
> index 831ec42..339b2c8 100644
> --- a/drivers/base/regmap/regmap.c
> +++ b/drivers/base/regmap/regmap.c
> @@ -343,7 +343,7 @@ struct regmap *regmap_init(struct device *dev,
>                goto err_map;
>        }
>
> -       regmap_debugfs_init(map);
> +       regmap_debugfs_init(map, config->name);
>
>        ret = regcache_init(map, config);
>        if (ret < 0)
> @@ -426,7 +426,7 @@ int regmap_reinit_cache(struct regmap *map, const struct regmap_config *config)
>        map->precious_reg = config->precious_reg;
>        map->cache_type = config->cache_type;
>
> -       regmap_debugfs_init(map);
> +       regmap_debugfs_init(map, config->name);
>
>        map->cache_bypass = false;
>        map->cache_only = false;
> diff --git a/include/linux/regmap.h b/include/linux/regmap.h
> index 48e9b86..2fd41e3 100644
> --- a/include/linux/regmap.h
> +++ b/include/linux/regmap.h
> @@ -46,6 +46,9 @@ struct reg_default {
>  /**
>  * Configuration for the register map of a device.
>  *
> + * @name: Optional name of the regmap. Useful when a device has multiple
> + *        register regions.
> + *
>  * @reg_bits: Number of bits in a register address, mandatory.
>  * @pad_bits: Number of bits of padding between register and value.
>  * @val_bits: Number of bits in a register value, mandatory.
> @@ -77,6 +80,8 @@ struct reg_default {
>  * @num_reg_defaults_raw: Number of elements in reg_defaults_raw.
>  */
>  struct regmap_config {
> +       const char *name;
> +
>        int reg_bits;
>        int pad_bits;
>        int val_bits;
> --
> 1.7.0.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
