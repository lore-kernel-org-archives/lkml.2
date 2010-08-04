Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab0HDEVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 00:21:18 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:50846 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab0HDEVO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 00:21:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=X07rrV3Uv4YwppsXaY+tetCe46/ZT1iVnS7i4zYM+RaMfXnRgfdwUgIHmfLQVtu6Kq
         O5EbN8L9bWBDjlcOAVMbK321R7sT/Y57yvuZIGSO9k3pNDUyAymg33jvHARMvrF2rliy
         busmUj/yVECg3aw17KQATu3wv1nM9Dn4Xpsdw=
MIME-Version: 1.0
In-Reply-To: <20100722173301.1512.52037.stgit@warthog.procyon.org.uk>
References: <20100722173251.1512.29858.stgit@warthog.procyon.org.uk>
	<20100722173301.1512.52037.stgit@warthog.procyon.org.uk>
Date: Tue, 3 Aug 2010 23:21:13 -0500
Message-ID: <AANLkTinA1Or90WZ1nAMtDs7+zJ_06rTXLW5ktf1oxq6w@mail.gmail.com>
Subject: Re: [PATCH 3/6] CIFS: Make cifs_convert_address() take a const src 
	pointer and a length
From: Steve French <smfrench@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: jlayton@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I merged this (patch 3) - but patch 4 (and thus patch 5) did not merge.

Also patches 4 and 5 had trivial checkpatch warnings.

Patch 6 looks afs related so should probably merge out of your tree,
but it doesn't matter to me.
What about patches 1 and 2 - which is easier?

On Thu, Jul 22, 2010 at 12:33 PM, David Howells <dhowells@redhat.com> wrote:
> Make cifs_convert_address() take a const src pointer and a length so that all
> the strlen() calls in their can be cut out and to make it unnecessary to modify
> the src string.
>
> Also return the data length from dns_resolve_server_name_to_ip() so that a
> strlen() can be cut out of cifs_compose_mount_options() too.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
>
>  fs/cifs/cifs_dfs_ref.c |    5 ++---
>  fs/cifs/cifsproto.h    |    4 ++--
>  fs/cifs/connect.c      |    1 +
>  fs/cifs/dns_resolve.c  |   20 +++++++++-----------
>  fs/cifs/netmisc.c      |   45 ++++++++++++++++++++++++---------------------
>  5 files changed, 38 insertions(+), 37 deletions(-)
>
> diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
> index ac19a6f..37543e8 100644
> --- a/fs/cifs/cifs_dfs_ref.c
> +++ b/fs/cifs/cifs_dfs_ref.c
> @@ -141,7 +141,7 @@ char *cifs_compose_mount_options(const char *sb_mountdata,
>        }
>
>        rc = dns_resolve_server_name_to_ip(*devname, &srvIP);
> -       if (rc != 0) {
> +       if (rc < 0) {
>                cERROR(1, "%s: Failed to resolve server part of %s to IP: %d",
>                          __func__, *devname, rc);
>                goto compose_mount_options_err;
> @@ -150,8 +150,7 @@ char *cifs_compose_mount_options(const char *sb_mountdata,
>         * assuming that we have 'unc=' and 'ip=' in
>         * the original sb_mountdata
>         */
> -       md_len = strlen(sb_mountdata) + strlen(srvIP) +
> -               strlen(ref->node_name) + 12;
> +       md_len = strlen(sb_mountdata) + rc + strlen(ref->node_name) + 12;
>        mountdata = kzalloc(md_len+1, GFP_KERNEL);
>        if (mountdata == NULL) {
>                rc = -ENOMEM;
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index 2eaebbd..1f54508 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -86,8 +86,8 @@ extern unsigned int smbCalcSize(struct smb_hdr *ptr);
>  extern unsigned int smbCalcSize_LE(struct smb_hdr *ptr);
>  extern int decode_negTokenInit(unsigned char *security_blob, int length,
>                        struct TCP_Server_Info *server);
> -extern int cifs_convert_address(struct sockaddr *dst, char *src);
> -extern int cifs_fill_sockaddr(struct sockaddr *dst, char *src,
> +extern int cifs_convert_address(struct sockaddr *dst, const char *src, int len);
> +extern int cifs_fill_sockaddr(struct sockaddr *dst, const char *src, int len,
>                                unsigned short int port);
>  extern int map_smb_to_linux_error(struct smb_hdr *smb, int logErr);
>  extern void header_assemble(struct smb_hdr *, char /* command */ ,
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 399b601..7a78b49 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -1538,6 +1538,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
>        if (volume_info->UNCip && volume_info->UNC) {
>                rc = cifs_fill_sockaddr((struct sockaddr *)&addr,
>                                        volume_info->UNCip,
> +                                       strlen(volume_info->UNCip),
>                                        volume_info->port);
>                if (!rc) {
>                        /* we failed translating address */
> diff --git a/fs/cifs/dns_resolve.c b/fs/cifs/dns_resolve.c
> index ff6fa2f..8de3b98 100644
> --- a/fs/cifs/dns_resolve.c
> +++ b/fs/cifs/dns_resolve.c
> @@ -40,11 +40,11 @@ static const struct cred *dns_resolver_cache;
>  *             0 - name is not IP
>  */
>  static int
> -is_ip(char *name)
> +is_ip(const char *name, int len)
>  {
>        struct sockaddr_storage ss;
>
> -       return cifs_convert_address((struct sockaddr *)&ss, name);
> +       return cifs_convert_address((struct sockaddr *)&ss, name, len);
>  }
>
>  static int
> @@ -54,6 +54,10 @@ dns_resolver_instantiate(struct key *key, const void *data,
>        int rc = 0;
>        char *ip;
>
> +       /* make sure this looks like an address */
> +       if (!is_ip(data, datalen))
> +               return -EINVAL;
> +
>        ip = kmalloc(datalen + 1, GFP_KERNEL);
>        if (!ip)
>                return -ENOMEM;
> @@ -61,12 +65,6 @@ dns_resolver_instantiate(struct key *key, const void *data,
>        memcpy(ip, data, datalen);
>        ip[datalen] = '\0';
>
> -       /* make sure this looks like an address */
> -       if (!is_ip(ip)) {
> -               kfree(ip);
> -               return -EINVAL;
> -       }
> -
>        key->type_data.x[0] = datalen;
>        key->payload.data = ip;
>
> @@ -93,7 +91,7 @@ struct key_type key_type_dns_resolver = {
>  *     unc - server UNC
>  * output:
>  *     *ip_addr - pointer to server ip, caller responcible for freeing it.
> - * return 0 on success
> + * return the length of the returned string on success
>  */
>  int
>  dns_resolve_server_name_to_ip(const char *unc, char **ip_addr)
> @@ -131,7 +129,7 @@ dns_resolve_server_name_to_ip(const char *unc, char **ip_addr)
>        memcpy(name, unc+2, len);
>        name[len] = 0;
>
> -       if (is_ip(name)) {
> +       if (is_ip(name, len)) {
>                cFYI(1, "%s: it is IP, skipping dns upcall: %s",
>                                        __func__, name);
>                data = name;
> @@ -164,7 +162,7 @@ skip_upcall:
>                                                        name,
>                                                        *ip_addr
>                                        );
> -                       rc = 0;
> +                       rc = len;
>                } else {
>                        rc = -ENOMEM;
>                }
> diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
> index 3489468..b7f5975 100644
> --- a/fs/cifs/netmisc.c
> +++ b/fs/cifs/netmisc.c
> @@ -139,17 +139,18 @@ static const struct smb_to_posix_error mapping_table_ERRHRD[] = {
>  * Returns 0 on failure.
>  */
>  static int
> -cifs_inet_pton(const int address_family, const char *cp, void *dst)
> +cifs_inet_pton(const int address_family, const char *cp, int len, void *dst)
>  {
>        int ret = 0;
>
>        /* calculate length by finding first slash or NULL */
>        if (address_family == AF_INET)
> -               ret = in4_pton(cp, -1 /* len */, dst, '\\', NULL);
> +               ret = in4_pton(cp, len, dst, '\\', NULL);
>        else if (address_family == AF_INET6)
> -               ret = in6_pton(cp, -1 /* len */, dst , '\\', NULL);
> +               ret = in6_pton(cp, len, dst , '\\', NULL);
>
> -       cFYI(DBG2, "address conversion returned %d for %s", ret, cp);
> +       cFYI(DBG2, "address conversion returned %d for %*.*s",
> +            ret, len, len, cp);
>        if (ret > 0)
>                ret = 1;
>        return ret;
> @@ -164,37 +165,39 @@ cifs_inet_pton(const int address_family, const char *cp, void *dst)
>  * Returns 0 on failure.
>  */
>  int
> -cifs_convert_address(struct sockaddr *dst, char *src)
> +cifs_convert_address(struct sockaddr *dst, const char *src, int len)
>  {
> -       int rc;
> -       char *pct, *endp;
> +       int rc, alen, slen;
> +       const char *pct;
> +       char *endp, scope_id[13];
>        struct sockaddr_in *s4 = (struct sockaddr_in *) dst;
>        struct sockaddr_in6 *s6 = (struct sockaddr_in6 *) dst;
>
>        /* IPv4 address */
> -       if (cifs_inet_pton(AF_INET, src, &s4->sin_addr.s_addr)) {
> +       if (cifs_inet_pton(AF_INET, src, len, &s4->sin_addr.s_addr)) {
>                s4->sin_family = AF_INET;
>                return 1;
>        }
>
> -       /* temporarily terminate string */
> -       pct = strchr(src, '%');
> -       if (pct)
> -               *pct = '\0';
> -
> -       rc = cifs_inet_pton(AF_INET6, src, &s6->sin6_addr.s6_addr);
> -
> -       /* repair temp termination (if any) and make pct point to scopeid */
> -       if (pct)
> -               *pct++ = '%';
> +       /* attempt to exclude the scope ID from the address part */
> +       pct = memchr(src, '%', len);
> +       alen = pct ? pct - src : len;
>
> +       rc = cifs_inet_pton(AF_INET6, src, alen, &s6->sin6_addr.s6_addr);
>        if (!rc)
>                return rc;
>
>        s6->sin6_family = AF_INET6;
>        if (pct) {
> +               /* grab the scope ID */
> +               slen = len - (alen + 1);
> +               if (slen <= 0 || slen > 12)
> +                       return 0;
> +               memcpy(scope_id, pct + 1, slen);
> +               scope_id[slen] = '\0';
> +
>                s6->sin6_scope_id = (u32) simple_strtoul(pct, &endp, 0);
> -               if (!*pct || *endp)
> +               if (endp != scope_id + slen)
>                        return 0;
>        }
>
> @@ -202,10 +205,10 @@ cifs_convert_address(struct sockaddr *dst, char *src)
>  }
>
>  int
> -cifs_fill_sockaddr(struct sockaddr *dst, char *src,
> +cifs_fill_sockaddr(struct sockaddr *dst, const char *src, int len,
>                   const unsigned short int port)
>  {
> -       if (!cifs_convert_address(dst, src))
> +       if (!cifs_convert_address(dst, src, len))
>                return 0;
>
>        switch (dst->sa_family) {
>
>



-- 
Thanks,

Steve
