Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab2DXMdK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 08:33:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60027 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753764Ab2DXMdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 08:33:07 -0400
Date: Tue, 24 Apr 2012 14:33:05 +0200
From: Michal Marek <mmarek@suse.cz>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Arnaud Lacombe <lacombar@gmail.com>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] kbuild: Add error handling to KCONFIG_ALL_CONFIG
Message-ID: <20120424123305.GA30068@sepie.suse.cz>
References: <m1aa22rllb.fsf@fess.ebiederm.org>
 <4F96705C.5030901@suse.cz>
 <m1aa21nxzg.fsf_-_@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1aa21nxzg.fsf_-_@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2012 at 04:57:39AM -0700, Eric W. Biederman wrote:
>  		name = getenv("KCONFIG_ALLCONFIG");
> -		if (name && !stat(name, &tmpstat)) {
> -			conf_read_simple(name, S_DEF_USER);
> +		if (name && name[0] != '\0') {
> +			if (conf_read_simple(name, S_DEF_USER)) {
> +				fprintf(stderr,
> +					_("*** Can't read seed configuration \"%s\"!\n"),
> +					name);
> +				exit(1);
> +			}
>  			break;
>  		}
>  		switch (input_mode) {


Before this patch, the code would fall back to a file named
all{no,yes,mod,def,random}.config and then to all.config. Now you require
$KCONFIG_ALLCONFIG to always be a file. I suggest we keep the fallback at
least for KCONFIG_ALLCONFIG=1, like this:


diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index f208f90..36efc8f 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -574,9 +574,17 @@ int main(int ac, char **av)
 	case alldefconfig:
 	case randconfig:
 		name = getenv("KCONFIG_ALLCONFIG");
-		if (name && !stat(name, &tmpstat)) {
-			conf_read_simple(name, S_DEF_USER);
-			break;
+		if (name && name[0] != '\0') {
+			if (conf_read_simple(name, S_DEF_USER)) {
+				if (strcmp(name, "1") != 0) {
+					fprintf(stderr,
+						_("*** Can't read seed configuration \"%s\"!\n"),
+						name);
+					exit(1);
+				}
+			} else {
+				break;
+			}
 		}
 		switch (input_mode) {
 		case allnoconfig:	name = "allno.config"; break;
@@ -586,10 +594,13 @@ int main(int ac, char **av)
 		case randconfig:	name = "allrandom.config"; break;
 		default: break;
 		}
-		if (!stat(name, &tmpstat))
-			conf_read_simple(name, S_DEF_USER);
-		else if (!stat("all.config", &tmpstat))
-			conf_read_simple("all.config", S_DEF_USER);
+		if (conf_read_simple(name, S_DEF_USER) &&
+				conf_read_simple("all.config", S_DEF_USER)) {
+			fprintf(stderr,
+				_("*** KCONFIG_ALLCONFIG=1 set, but no \"%s\" or \"all.config\" file found\n"),
+				name);
+			exit(1);
+		}
 		break;
 	default:
 		break;


And update Documentation/kbuild/kconfig.txt.

Michal
