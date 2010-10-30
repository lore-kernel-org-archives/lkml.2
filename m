Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762207Ab0J3A0t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 20:26:49 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38918 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122Ab0J3A0s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 20:26:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fD9psr3wjVmRUJ3w9Jb09kEFEf6vm0nIjHn7uKjrtYw8Ci+negxILeV9JiiNWEwMFq
         R/kbXyNH9zFwl20Oh1/QC11FzlL/v+G2Vh3KHvVpiKNY1luZKvVz6rf8J8UnAPd+EPMV
         ftMa9crNdHDl3HTyaKCQ1kYBi0q2tsj2auVoc=
MIME-Version: 1.0
In-Reply-To: <20101029054423.498608001@goodmis.org>
References: <20101029054310.790179545@goodmis.org>
	<20101029054423.498608001@goodmis.org>
Date: Fri, 29 Oct 2010 20:26:46 -0400
Message-ID: <AANLkTi=a8dp-WUNHAkx2fZ5GgNHmDw+ee7MDeUSL44Z0@mail.gmail.com>
Subject: Re: [PATCH 1/5] [PATCH 1/5] kconfig: Make localmodconfig handle
 environment variables
From: Arnaud Lacombe <lacombar@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        Sam Ravnborg <sam@ravnborg.org>, Roman Zippel <zippel@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Oct 29, 2010 at 1:43 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> From: Steven Rostedt <srostedt@redhat.com>
>
> The commit 838a2e55e6a4e9e8a10451ed2ef0f7a08dabdb04
>  kbuild: migrate all arch to the kconfig mainmenu upgrade
>
> Broke make localmodconfig. The reason was that it added a
> environment variable to the kconfig source, which the
> streamline_config.pl could not handle.
>
Technically, it is _not_ an environment variable; it is a kconfig
symbol's name. In this particular case, both name collide and the
kconfig symbol happens to get its default value from the environment.
The real fixes, from my point of view, would be to have a perl binding
of the kconfig backend and get rid of read_kconfig(). That said, your
patch is broken if a symbol happen not to match an environment
variable (both in name and value).

Btw, two questions:
 - who has authority on kconfig ? Michal or you ? MAINTAINERS say
"Roman Zippel", but AFAIK, this is no longer valid.
 - what is the delay someone in CC: is given the time to answer a
patch ? I see that this one particularly is already in Linus' tree.

Thanks,
 - Arnaud

> This patch changes streamline_config.pl to handle kconfig sources
> using environment variables in their names.
>
> Cc: Arnaud Lacombe <lacombar@gmail.com>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: Michal Marek <mmarek@suse.cz>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  scripts/kconfig/streamline_config.pl |   12 +++++++++++-
>  1 files changed, 11 insertions(+), 1 deletions(-)
>
> diff --git a/scripts/kconfig/streamline_config.pl b/scripts/kconfig/streamline_config.pl
> index c70a27d..cc10bcf 100644
> --- a/scripts/kconfig/streamline_config.pl
> +++ b/scripts/kconfig/streamline_config.pl
> @@ -137,7 +137,17 @@ sub read_kconfig {
>     my $config;
>     my @kconfigs;
>
> -    open(KIN, "$ksource/$kconfig") || die "Can't open $kconfig";
> +    my $source = "$ksource/$kconfig";
> +    my $last_source = "";
> +
> +    # Check for any environment variables used
> +    while ($source =~ /\$(\w+)/ && $last_source ne $source) {
> +       my $env = $1;
> +       $last_source = $source;
> +       $source =~ s/\$$env/$ENV{$env}/;
> +    }
> +
> +    open(KIN, "$source") || die "Can't open $kconfig";
>     while (<KIN>) {
>        chomp;
>
> --
> 1.7.1
>
>
>
