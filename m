Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971Ab0HQFm2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 01:42:28 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56831 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786Ab0HQFm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 01:42:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gKuvd736FOcgDHj1fdcD7oqnweM51tFgeXzGbyfNbA3KbBgcLU+ZrTfABbDAnszJ8Z
         +MafngOwOBw40giiT1GPc1FUtSKY/NVZKeMh2BE57vMzm4f6L6CQx5Vs7WOiHapSzfwF
         4sCNVKWTgcMlC26Nvn9jZKkeluKJufbzPkMm4=
Date: Tue, 17 Aug 2010 13:46:40 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kbuild@vger.kernel.org, Roman Zippel <zippel@linux-m68k.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kconfig: fix warnings in fgets/fwrite usage
Message-ID: <20100817054640.GD5095@cr0.nay.redhat.com>
References: <1281592579-343-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281592579-343-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 01:56:19AM -0400, Mike Frysinger wrote:
>Add some helper functions that abort on failure, and change the fwrite
>and fget calls to use those.  This should kill off all the ugly gcc
>warnings that some distros emit about ignoring return values due to
>usage of warn_unused_result attributes.
>
>Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Looks good to me,

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>


>---
> scripts/kconfig/conf.c     |    4 ++--
> scripts/kconfig/confdata.c |    2 +-
> scripts/kconfig/expr.c     |    2 +-
> scripts/kconfig/lkc.h      |   24 ++++++++++++++++++++++++
> 4 files changed, 28 insertions(+), 4 deletions(-)
>
>diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
>index 274f271..b382a39 100644
>--- a/scripts/kconfig/conf.c
>+++ b/scripts/kconfig/conf.c
>@@ -108,7 +108,7 @@ static int conf_askvalue(struct symbol *sym, const char *def)
> 		check_stdin();
> 	case oldaskconfig:
> 		fflush(stdout);
>-		fgets(line, 128, stdin);
>+		xfgets(line, 128, stdin);
> 		return 1;
> 	default:
> 		break;
>@@ -306,7 +306,7 @@ static int conf_choice(struct menu *menu)
> 			check_stdin();
> 		case oldaskconfig:
> 			fflush(stdout);
>-			fgets(line, 128, stdin);
>+			xfgets(line, 128, stdin);
> 			strip(line);
> 			if (line[0] == '?') {
> 				print_help(menu);
>diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
>index f81f263..7d9f271 100644
>--- a/scripts/kconfig/confdata.c
>+++ b/scripts/kconfig/confdata.c
>@@ -412,7 +412,7 @@ static void conf_write_string(bool headerfile, const char *name,
> 	while (1) {
> 		l = strcspn(str, "\"\\");
> 		if (l) {
>-			fwrite(str, l, 1, out);
>+			xfwrite(str, l, 1, out);
> 			str += l;
> 		}
> 		if (!*str)
>diff --git a/scripts/kconfig/expr.c b/scripts/kconfig/expr.c
>index 8f18e37..330e7c0 100644
>--- a/scripts/kconfig/expr.c
>+++ b/scripts/kconfig/expr.c
>@@ -1087,7 +1087,7 @@ void expr_print(struct expr *e, void (*fn)(void *, struct symbol *, const char *
> 
> static void expr_print_file_helper(void *data, struct symbol *sym, const char *str)
> {
>-	fwrite(str, strlen(str), 1, data);
>+	xfwrite(str, strlen(str), 1, data);
> }
> 
> void expr_fprint(struct expr *e, FILE *out)
>diff --git a/scripts/kconfig/lkc.h b/scripts/kconfig/lkc.h
>index 76db065..a3bd66a 100644
>--- a/scripts/kconfig/lkc.h
>+++ b/scripts/kconfig/lkc.h
>@@ -169,6 +169,30 @@ static inline bool sym_has_value(struct symbol *sym)
> 	return sym->flags & SYMBOL_DEF_USER ? true : false;
> }
> 
>+#define internal_error(fmt, args...) \
>+do { \
>+	fprintf(stderr, "%s:%s:%i: %s: " fmt "\n", __FILE__, \
>+		__func__, __LINE__, _("internal error"), ## args); \
>+	exit(1); \
>+} while (0)
>+
>+#define xfwrite(ptr, size, nmemb, stream) \
>+({ \
>+	size_t _nmemb = (nmemb); \
>+	size_t ret = fwrite(ptr, size, _nmemb, stream); \
>+	if (ret != _nmemb) \
>+		internal_error("%s", _("fwrite() came up short")); \
>+	ret; \
>+})
>+
>+#define xfgets(s, size, stream) \
>+({ \
>+	char *ret = fgets(s, size, stream); \
>+	if (ret == NULL) \
>+		internal_error("%s", _("fgets() came up short")); \
>+	ret; \
>+})
>+
> #ifdef __cplusplus
> }
> #endif
>-- 
>1.7.2
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
