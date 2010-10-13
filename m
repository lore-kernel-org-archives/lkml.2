Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447Ab0JMNw2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 09:52:28 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:58063 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239Ab0JMNw1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 09:52:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=OJaGimGHBlA6Cj7D2AU08hABQibtbJWpD+cmKv9AJPrC7Buc2uNrnVpWdlfDbqsH8H
         qqkXUmoBUvxPVNiPGHR0FWVM5us7heMqG9KvXYL6JCkRLPcT3tks6Y1oP1xhs53EtceA
         cxflFGrDlXqU5mhzPLPj7jFL8yZA+4yqyXfZk=
MIME-Version: 1.0
In-Reply-To: <1286971481-14443-1-git-send-email-santoscadenas@gmail.com>
References: <1286971481-14443-1-git-send-email-santoscadenas@gmail.com>
From: Jose Antonio Santos Cadenas <santoscadenas@gmail.com>
Date: Wed, 13 Oct 2010 15:52:03 +0200
Message-ID: <AANLkTins1rcxfOtXf-Sas0G8vtgiGtoFTWiOFQ9FEaxR@mail.gmail.com>
Subject: Re: [PATCH] Some code cleanup in hdp
To: linux-kernel@vger.kernel.org
Cc: Jose Antonio Santos Cadenas <santoscadenas@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, wrong mailing list.

2010/10/13 Jose Antonio Santos Cadenas <santoscadenas@gmail.com>:
> ---
>  health/hdp.c      |   38 ++++++++++++++++++++++----------------
>  health/hdp_util.c |   29 ++++++++++++++++++-----------
>  2 files changed, 40 insertions(+), 27 deletions(-)
>
> diff --git a/health/hdp.c b/health/hdp.c
> index 4a6da78..954b6d6 100644
> --- a/health/hdp.c
> +++ b/health/hdp.c
> @@ -305,11 +305,12 @@ static DBusMessage *manager_create_application(DBusConnection *conn,
>        const char *name;
>        DBusMessageIter iter;
>        GError *err = NULL;
> -       DBusMessage *reply;
>
>        dbus_message_iter_init(msg, &iter);
>        app = hdp_get_app_config(&iter, &err);
>        if (err) {
> +               DBusMessage *reply;
> +
>                reply = g_dbus_create_error(msg,
>                                        ERROR_INTERFACE ".InvalidArguments",
>                                        "Invalid arguments: %s", err->message);
> @@ -439,12 +440,13 @@ static void abort_mdl_cb(GError *err, gpointer data)
>  static void hdp_mdl_reconn_cb(struct mcap_mdl *mdl, GError *err, gpointer data)
>  {
>        struct hdp_tmp_dc_data *dc_data = data;
> -       struct hdp_channel *chan = dc_data->hdp_chann;
> -       GError *gerr = NULL;
>        DBusMessage *reply;
>        int fd;
>
>        if (err) {
> +               struct hdp_channel *chan = dc_data->hdp_chann;
> +               GError *gerr = NULL;
> +
>                error("%s", err->message);
>                reply = g_dbus_create_error(dc_data->msg,
>                                        ERROR_INTERFACE ".HealthError",
> @@ -633,12 +635,13 @@ static void health_channel_destroy(void *data)
>  {
>        struct hdp_channel *hdp_chan = data;
>        struct hdp_device *dev = hdp_chan->dev;
> -       char *empty_path;
>
>        DBG("Destroy Health Channel %s", hdp_chan->path);
>        dev->channels = g_slist_remove(dev->channels, hdp_chan);
>
>        if (hdp_chan == dev->fr) {
> +               char *empty_path;
> +
>                dev->fr = NULL;
>                empty_path = "";
>                emit_property_changed(dev->conn, device_get_path(dev->dev),
> @@ -754,8 +757,6 @@ static void hdp_mcap_mdl_connected_cb(struct mcap_mdl *mdl, void *data)
>  {
>        struct hdp_device *dev = data;
>        struct hdp_channel *chan;
> -       GIOChannel *io_chan;
> -       int fd;
>
>        DBG("hdp_mcap_mdl_connected_cb");
>        if (!dev->ndc)
> @@ -769,16 +770,19 @@ static void hdp_mcap_mdl_connected_cb(struct mcap_mdl *mdl, void *data)
>                dev->channels = g_slist_prepend(dev->channels, chan);
>
>        if (chan->mdep == HDP_MDEP_ECHO) {
> +               GIOChannel *io;
> +               int fd;
> +
>                fd = mcap_mdl_get_fd(chan->mdl);
>                if (fd < 0)
>                        return;
>
>                chan->echo_done = FALSE;
> -               io_chan = g_io_channel_unix_new(fd);
> -               chan->wid = g_io_add_watch(io_chan,
> +               io = g_io_channel_unix_new(fd);
> +               chan->wid = g_io_add_watch(io,
>                                G_IO_ERR | G_IO_HUP | G_IO_NVAL | G_IO_IN,
>                                serve_echo, chan);
> -               g_io_channel_unref(io_chan);
> +               g_io_channel_unref(io);
>                return;
>        }
>
> @@ -859,8 +863,6 @@ static uint8_t hdp_mcap_mdl_conn_req_cb(struct mcap_mcl *mcl, uint8_t mdepid,
>  {
>        struct hdp_device *dev = data;
>        struct hdp_application *app;
> -       struct hdp_channel *chan;
> -       char *path;
>        GSList *l;
>
>        DBG("Data channel request");
> @@ -922,7 +924,9 @@ static uint8_t hdp_mcap_mdl_conn_req_cb(struct mcap_mcl *mcl, uint8_t mdepid,
>
>        l = g_slist_find_custom(dev->channels, &mdlid, cmp_chan_mdlid);
>        if (l) {
> -               chan = l->data;
> +               struct hdp_channel *chan = l->data;
> +               char *path;
> +
>                path = g_strdup(chan->path);
>                g_dbus_unregister_interface(dev->conn, path, HEALTH_CHANNEL);
>                g_free(path);
> @@ -981,16 +985,17 @@ gboolean hdp_set_mcl_cb(struct hdp_device *device, GError **err)
>
>  static void mcl_connected(struct mcap_mcl *mcl, gpointer data)
>  {
> -       struct hdp_adapter *hdp_adapter = data;
>        struct hdp_device *hdp_device;
> -       struct btd_device *device;
>        bdaddr_t addr;
> -       char str[18];
>        GSList *l;
>
>        mcap_mcl_get_addr(mcl, &addr);
>        l = g_slist_find_custom(devices, &addr, cmp_dev_addr);
>        if (!l) {
> +               struct hdp_adapter *hdp_adapter = data;
> +               struct btd_device *device;
> +               char str[18];
> +
>                ba2str(&addr, str);
>                device = adapter_get_device(connection,
>                                        hdp_adapter->btd_adapter, str);
> @@ -1088,7 +1093,6 @@ static void check_devices_mcl()
>  {
>        struct hdp_device *dev;
>        GSList *l, *to_delete = NULL;
> -       const char *path;
>
>        for (l = devices; l; l = l->next) {
>                dev = l->data;
> @@ -1101,6 +1105,8 @@ static void check_devices_mcl()
>        }
>
>        for (l = to_delete; l; l = l->next) {
> +               const char *path;
> +
>                path = device_get_path(dev->dev);
>                g_dbus_unregister_interface(dev->conn, path, HEALTH_DEVICE);
>        }
> diff --git a/health/hdp_util.c b/health/hdp_util.c
> index ef76b15..c5dfb01 100644
> --- a/health/hdp_util.c
> +++ b/health/hdp_util.c
> @@ -141,12 +141,14 @@ static gboolean parse_data_type(DBusMessageIter *iter, gpointer data,
>                                                                GError **err)
>  {
>        struct hdp_application *app = data;
> -       DBusMessageIter *value, variant;
> +       DBusMessageIter *value;
>        int ctype;
>
>        ctype = dbus_message_iter_get_arg_type(iter);
>        value = iter;
>        if (ctype == DBUS_TYPE_VARIANT) {
> +               DBusMessageIter variant;
> +
>                /* Get value inside the variable */
>                dbus_message_iter_recurse(iter, &variant);
>                ctype = dbus_message_iter_get_arg_type(&variant);
> @@ -167,13 +169,14 @@ static gboolean parse_data_type(DBusMessageIter *iter, gpointer data,
>  static gboolean parse_role(DBusMessageIter *iter, gpointer data, GError **err)
>  {
>        struct hdp_application *app = data;
> -       DBusMessageIter value;
>        DBusMessageIter *string;
>        int ctype;
>        const char *role;
>
>        ctype = dbus_message_iter_get_arg_type(iter);
>        if (ctype == DBUS_TYPE_VARIANT) {
> +               DBusMessageIter value;
> +
>                /* Get value inside the variable */
>                dbus_message_iter_recurse(iter, &value);
>                ctype = dbus_message_iter_get_arg_type(&value);
> @@ -206,12 +209,14 @@ static gboolean parse_role(DBusMessageIter *iter, gpointer data, GError **err)
>  static gboolean parse_desc(DBusMessageIter *iter, gpointer data, GError **err)
>  {
>        struct hdp_application *app = data;
> -       DBusMessageIter *string, variant;
> +       DBusMessageIter *string;
>        int ctype;
>        const char *desc;
>
>        ctype = dbus_message_iter_get_arg_type(iter);
>        if (ctype == DBUS_TYPE_VARIANT) {
> +               DBusMessageIter variant;
> +
>                /* Get value inside the variable */
>                dbus_message_iter_recurse(iter, &variant);
>                ctype = dbus_message_iter_get_arg_type(&variant);
> @@ -234,12 +239,14 @@ static gboolean parse_chan_type(DBusMessageIter *iter, gpointer data,
>                                                                GError **err)
>  {
>        struct hdp_application *app = data;
> -       DBusMessageIter *value, variant;
> +       DBusMessageIter *value;
>        int ctype;
>
>        ctype = dbus_message_iter_get_arg_type(iter);
>        value = iter;
>        if (ctype == DBUS_TYPE_VARIANT) {
> +               DBusMessageIter variant;
> +
>                /* Get value inside the variable */
>                dbus_message_iter_recurse(iter, &variant);
>                ctype = dbus_message_iter_get_arg_type(&variant);
> @@ -294,11 +301,11 @@ fail:
>
>  static gboolean is_app_role(GSList *app_list, HdpRole role)
>  {
> -       struct hdp_application *app;
>        GSList *l;
>
>        for (l = app_list; l; l = l->next) {
> -               app = l->data;
> +               struct hdp_application *app = l->data;
> +
>                if (app->role == role)
>                        return TRUE;
>        }
> @@ -732,7 +739,7 @@ static gboolean check_role(uint8_t rec_role, uint8_t app_role)
>  static gboolean get_mdep_from_rec(const sdp_record_t *rec, uint8_t role,
>                                uint16_t d_type, uint8_t *mdep, char **desc)
>  {
> -       sdp_data_t *list, *feat, *data_type, *mdepid, *role_t, *desc_t;
> +       sdp_data_t *list, *feat;
>
>        if (!desc && !mdep)
>                return TRUE;
> @@ -744,6 +751,8 @@ static gboolean get_mdep_from_rec(const sdp_record_t *rec, uint8_t role,
>                return FALSE;
>
>        for (feat = list->val.dataseq; feat; feat = feat->next) {
> +               sdp_data_t *data_type, *mdepid, *role_t, *desc_t;
> +
>                if (feat->dtd != SDP_SEQ8 && feat->dtd != SDP_SEQ16 &&
>                                                feat->dtd != SDP_SEQ32)
>                        continue;
> @@ -931,10 +940,9 @@ static gboolean hdp_get_add_prot_desc_list(const sdp_record_t *rec,
>  static gboolean get_ccpsm(sdp_list_t *recs, uint16_t *ccpsm)
>  {
>        sdp_list_t *l;
> -       sdp_record_t *rec;
>
>        for (l = recs; l; l = l->next) {
> -               rec = l->data;
> +               sdp_record_t *rec = l->data;
>
>                if (hdp_get_prot_desc_list(rec, ccpsm, NULL))
>                        return TRUE;
> @@ -946,10 +954,9 @@ static gboolean get_ccpsm(sdp_list_t *recs, uint16_t *ccpsm)
>  static gboolean get_dcpsm(sdp_list_t *recs, uint16_t *dcpsm)
>  {
>        sdp_list_t *l;
> -       sdp_record_t *rec;
>
>        for (l = recs; l; l = l->next) {
> -               rec = l->data;
> +               sdp_record_t *rec = l->data;
>
>                if (hdp_get_add_prot_desc_list(rec, dcpsm))
>                        return TRUE;
> --
> 1.7.1
>
>
