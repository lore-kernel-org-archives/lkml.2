Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118Ab1BMV7z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 16:59:55 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47310 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125Ab1BMV7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 16:59:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=LdGxqeyhMVw58kGRB2pxMafsYetMknlMro3m9WWPzrsLhQBMYgbCFyT4C7o9BhQGcX
         nj8htPpKUuGwql8i2st8bQllbF1M5pCbVe89flKH8zj2pBxra6REtf9u7r+tB5rbpETT
         qgOQaSRneNZ3IUPEcQQ8biBBzRxN1AfhtT1Bg=
Message-ID: <4D585450.2050900@gmail.com>
Date: Sun, 13 Feb 2011 22:59:44 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, clemens@ladisch.de,
        broonie@opensource.wolfsonmicro.com,
        sakari.ailus@maxwell.research.nokia.com
Subject: Re: [PATCH v8 07/12] media: Entities, pads and links enumeration
References: <1296131437-29954-1-git-send-email-laurent.pinchart@ideasonboard.com> <1296131437-29954-8-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1296131437-29954-8-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

Please see my little comment below..

On 2011-01-27 13:30, Laurent Pinchart wrote:
> Create the following two ioctls and implement them at the media device
> level to enumerate entities, pads and links.
> 
> - MEDIA_IOC_ENUM_ENTITIES: Enumerate entities and their properties
> - MEDIA_IOC_ENUM_LINKS: Enumerate all pads and links for a given entity
> 
> Entity IDs can be non-contiguous. Userspace applications should
> enumerate entities using the MEDIA_ENT_ID_FLAG_NEXT flag. When the flag
> is set in the entity ID, the MEDIA_IOC_ENUM_ENTITIES will return the
> next entity with an ID bigger than the requested one.
> 
> Only forward links that originate at one of the entity's source pads are
> returned during the enumeration process.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
> ---
>  Documentation/DocBook/media-entities.tmpl          |    8 +
>  Documentation/DocBook/v4l/media-controller.xml     |    2 +
>  .../DocBook/v4l/media-ioc-device-info.xml          |    3 +-
>  .../DocBook/v4l/media-ioc-enum-entities.xml        |  308 ++++++++++++++++++++
>  Documentation/DocBook/v4l/media-ioc-enum-links.xml |  202 +++++++++++++
>  drivers/media/media-device.c                       |  123 ++++++++
>  include/linux/media.h                              |   85 ++++++
>  include/media/media-entity.h                       |   24 +--
>  8 files changed, 731 insertions(+), 24 deletions(-)
>  create mode 100644 Documentation/DocBook/v4l/media-ioc-enum-entities.xml
>  create mode 100644 Documentation/DocBook/v4l/media-ioc-enum-links.xml
> 
...
> diff --git a/Documentation/DocBook/v4l/media-ioc-enum-links.xml b/Documentation/DocBook/v4l/media-ioc-enum-links.xml
> new file mode 100644
> index 0000000..daf0360
> --- /dev/null
> +++ b/Documentation/DocBook/v4l/media-ioc-enum-links.xml
> @@ -0,0 +1,202 @@
> +<refentry id="media-ioc-enum-links">
> +  <refmeta>
> +    <refentrytitle>ioctl MEDIA_IOC_ENUM_LINKS</refentrytitle>
> +    &manvol;
> +  </refmeta>
> +
> +  <refnamediv>
> +    <refname>MEDIA_IOC_ENUM_LINKS</refname>
> +    <refpurpose>Enumerate all pads and links for a given entity</refpurpose>
> +  </refnamediv>
> +
> +  <refsynopsisdiv>
> +    <funcsynopsis>
> +      <funcprototype>
> +	<funcdef>int <function>ioctl</function></funcdef>
> +	<paramdef>int <parameter>fd</parameter></paramdef>
> +	<paramdef>int <parameter>request</parameter></paramdef>
> +	<paramdef>struct media_links_enum *<parameter>argp</parameter></paramdef>
> +      </funcprototype>
> +    </funcsynopsis>
> +  </refsynopsisdiv>
> +
> +  <refsect1>
> +    <title>Arguments</title>
> +
> +    <variablelist>
> +      <varlistentry>
> +	<term><parameter>fd</parameter></term>
> +	<listitem>
> +	  <para>File descriptor returned by
> +	  <link linkend='media-func-open'><function>open()</function></link>.</para>
> +	</listitem>
> +      </varlistentry>
> +      <varlistentry>
> +	<term><parameter>request</parameter></term>
> +	<listitem>
> +	  <para>MEDIA_IOC_ENUM_LINKS</para>
> +	</listitem>
> +      </varlistentry>
> +      <varlistentry>
> +	<term><parameter>argp</parameter></term>
> +	<listitem>
> +	  <para></para>
> +	</listitem>
> +      </varlistentry>
> +    </variablelist>
> +  </refsect1>
> +
> +  <refsect1>
> +    <title>Description</title>
> +
> +    <para>To enumerate pads and/or links for a given entity, applications set
> +    the entity field of a &media-links-enum; structure and initialize the
> +    &media-pad-desc; and &media-link-desc; structure arrays pointed by the
> +    <structfield>pads</structfield> and <structfield>links</structfield> fields.
> +    They then call the MEDIA_IOC_ENUM_LINKS ioctl with a pointer to this
> +    structure.</para>
> +    <para>If the <structfield>pads</structfield> field is not NULL, the driver
> +    fills the <structfield>pads</structfield> array with information about the
> +    entity's pads. The array must have enough room to store all the entity's
> +    pads. The number of pads can be retrieved with the &MEDIA-IOC-ENUM-ENTITIES;
> +    ioctl.</para>
> +    <para>If the <structfield>links</structfield> field is not NULL, the driver
> +    fills the <structfield>links</structfield> array with information about the
> +    entity's outbound links. The array must have enough room to store all the
> +    entity's outbound links. The number of outbound links can be retrieved with
> +    the &MEDIA-IOC-ENUM-ENTITIES; ioctl.</para>
> +    <para>Only forward links that originate at one of the entity's source pads
> +    are returned during the enumeration process.</para>
> +
> +    <table pgwide="1" frame="none" id="media-links-enum">
> +      <title>struct <structname>media_links_enum</structname></title>
> +      <tgroup cols="3">
> +        &cs-str;
> +	<tbody valign="top">
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>entity</structfield></entry>
> +	    <entry>Entity id, set by the application.</entry>
> +	  </row>
> +	  <row>
> +	    <entry>struct &media-pad-desc;</entry>
> +	    <entry>*<structfield>pads</structfield></entry>
> +	    <entry>Pointer to a pads array allocated by the application. Ignored
> +	    if NULL.</entry>
> +	  </row>
> +	  <row>
> +	    <entry>struct &media-link-desc;</entry>
> +	    <entry>*<structfield>links</structfield></entry>
> +	    <entry>Pointer to a links array allocated by the application. Ignored
> +	    if NULL.</entry>
> +	  </row>
> +	</tbody>
> +      </tgroup>
> +    </table>
> +
> +    <table pgwide="1" frame="none" id="media-pad-desc">
> +      <title>struct <structname>media_pad_desc</structname></title>
> +      <tgroup cols="3">
> +        &cs-str;
> +	<tbody valign="top">
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>entity</structfield></entry>
> +	    <entry>ID of the entity this pad belongs to.</entry>
> +	  </row>
> +	  <row>
> +	    <entry>__u16</entry>
> +	    <entry><structfield>index</structfield></entry>
> +	    <entry>0-based pad index.</entry>
> +	  </row>
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>flags</structfield></entry>
> +	    <entry>Pad flags, see <xref linkend="media-pad-flag" /> for more details.</entry>
> +	  </row>
> +	</tbody>
> +      </tgroup>
> +    </table>
> +
> +    <table frame="none" pgwide="1" id="media-pad-flag">
> +      <title>Media pad flags</title>
> +      <tgroup cols="2">
> +        <colspec colname="c1"/>
> +        <colspec colname="c2"/>
> +	<tbody valign="top">
> +	  <row>
> +	    <entry><constant>MEDIA_PAD_FL_INPUT</constant></entry>
> +	    <entry>Input pad, relative to the entity. Input pads sink data and
> +	    are targets of links.</entry>
> +	  </row>
> +	  <row>
> +	    <entry><constant>MEDIA_PAD_FL_OUTPUT</constant></entry>
> +	    <entry>Output pad, relative to the entity. Output pads source data
> +	    and are origins of links.</entry>
> +	  </row>
> +	</tbody>
> +      </tgroup>
> +    </table>
> +
> +    <table pgwide="1" frame="none" id="media-link-desc">
> +      <title>struct <structname>media_links_enum</structname></title>

..the above line should perhaps be:

> +      <title>struct <structname>media_links_desc</structname></title>

as "struct media_links_desc" is described above.

BTW, I was wondering how one makes use of the pads associated with
a media entity of type other than MEDIA_ENT_T_V4L2_SUBDEV*,
e.g. V4L2 device - MEDIA_ENT_T_DEVNODE_V4L.

I guess new standard ioctls should be added for per pads operations
at V4L2 device, similarly is it is done with v4l2-subdevs.
Is this right?


Regards,
Sylwester

