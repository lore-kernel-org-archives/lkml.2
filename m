Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275Ab2GQWsd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 18:48:33 -0400
Received: from trem.minaslivre.org ([74.50.53.205]:50659 "EHLO
	grilo.cascardo.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755078Ab2GQWs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 18:48:29 -0400
Date: Tue, 17 Jul 2012 19:47:50 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Miguel =?utf-8?B?R8OzbWV6?= <magomez@igalia.com>
Cc: don@syst.com.br, mjg@redhat.com, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1 v2] classmate-laptop: Add support for Classmate V4
 accelerometer.
Message-ID: <20120717224749.GA20813@nautilus.holoscopio.com>
References: <cover.1340976795.git.magomez@igalia.com>
 <39ac42c709e498fbef4f0f0f24edc5331e5f4473.1340976795.git.magomez@igalia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HcAYCG3uE/tztfnV"
Content-Disposition: inline
In-Reply-To: <39ac42c709e498fbef4f0f0f24edc5331e5f4473.1340976795.git.magomez@igalia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 29, 2012 at 03:39:48PM +0200, Miguel G=C3=B3mez wrote:
> Classmate V4 laptop includes a new accelerometer that can't be handled by
> previous driver. This patch adds a new driver to handle it.
>=20
> Signed-off-by: Miguel G=C3=B3mez <magomez@igalia.com>

Hi, Miguel.

This seems OK to me. Thanks for this work. Do you have the other
functionality of the driver working? I am interested to know if you have
the function buttons working.

Regards.
Cascardo.

Acked-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>

> ---
>  drivers/platform/x86/classmate-laptop.c |  400 +++++++++++++++++++++++++=
+++++-
>  1 file changed, 398 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/platform/x86/classmate-laptop.c b/drivers/platform/x=
86/classmate-laptop.c
> index 94f93b6..5de01bc 100644
> --- a/drivers/platform/x86/classmate-laptop.c
> +++ b/drivers/platform/x86/classmate-laptop.c
> @@ -31,12 +31,18 @@ MODULE_LICENSE("GPL");
> =20
>  struct cmpc_accel {
>  	int sensitivity;
> +	int g_select;
> +	int inputdev_state;
>  };
> =20
> -#define CMPC_ACCEL_SENSITIVITY_DEFAULT		5
> +#define CMPC_ACCEL_DEV_STATE_CLOSED	0
> +#define CMPC_ACCEL_DEV_STATE_OPEN	1
> =20
> +#define CMPC_ACCEL_SENSITIVITY_DEFAULT		5
> +#define CMPC_ACCEL_G_SELECT_DEFAULT		0
> =20
>  #define CMPC_ACCEL_HID		"ACCE0000"
> +#define CMPC_ACCEL_HID_V4	"ACCE0001"
>  #define CMPC_TABLET_HID		"TBLT0000"
>  #define CMPC_IPML_HID	"IPML200"
>  #define CMPC_KEYS_HID		"FnBT0000"
> @@ -76,7 +82,388 @@ static int cmpc_remove_acpi_notify_device(struct acpi=
_device *acpi)
>  }
> =20
>  /*
> - * Accelerometer code.
> + * Accelerometer code for Classmate V4
> + */
> +static acpi_status cmpc_start_accel_v4(acpi_handle handle)
> +{
> +	union acpi_object param[4];
> +	struct acpi_object_list input;
> +	acpi_status status;
> +
> +	param[0].type =3D ACPI_TYPE_INTEGER;
> +	param[0].integer.value =3D 0x3;
> +	param[1].type =3D ACPI_TYPE_INTEGER;
> +	param[1].integer.value =3D 0;
> +	param[2].type =3D ACPI_TYPE_INTEGER;
> +	param[2].integer.value =3D 0;
> +	param[3].type =3D ACPI_TYPE_INTEGER;
> +	param[3].integer.value =3D 0;
> +	input.count =3D 4;
> +	input.pointer =3D param;
> +	status =3D acpi_evaluate_object(handle, "ACMD", &input, NULL);
> +	return status;
> +}
> +
> +static acpi_status cmpc_stop_accel_v4(acpi_handle handle)
> +{
> +	union acpi_object param[4];
> +	struct acpi_object_list input;
> +	acpi_status status;
> +
> +	param[0].type =3D ACPI_TYPE_INTEGER;
> +	param[0].integer.value =3D 0x4;
> +	param[1].type =3D ACPI_TYPE_INTEGER;
> +	param[1].integer.value =3D 0;
> +	param[2].type =3D ACPI_TYPE_INTEGER;
> +	param[2].integer.value =3D 0;
> +	param[3].type =3D ACPI_TYPE_INTEGER;
> +	param[3].integer.value =3D 0;
> +	input.count =3D 4;
> +	input.pointer =3D param;
> +	status =3D acpi_evaluate_object(handle, "ACMD", &input, NULL);
> +	return status;
> +}
> +
> +static acpi_status cmpc_accel_set_sensitivity_v4(acpi_handle handle, int=
 val)
> +{
> +	union acpi_object param[4];
> +	struct acpi_object_list input;
> +
> +	param[0].type =3D ACPI_TYPE_INTEGER;
> +	param[0].integer.value =3D 0x02;
> +	param[1].type =3D ACPI_TYPE_INTEGER;
> +	param[1].integer.value =3D val;
> +	param[2].type =3D ACPI_TYPE_INTEGER;
> +	param[2].integer.value =3D 0;
> +	param[3].type =3D ACPI_TYPE_INTEGER;
> +	param[3].integer.value =3D 0;
> +	input.count =3D 4;
> +	input.pointer =3D param;
> +	return acpi_evaluate_object(handle, "ACMD", &input, NULL);
> +}
> +
> +static acpi_status cmpc_accel_set_g_select_v4(acpi_handle handle, int va=
l)
> +{
> +	union acpi_object param[4];
> +	struct acpi_object_list input;
> +
> +	param[0].type =3D ACPI_TYPE_INTEGER;
> +	param[0].integer.value =3D 0x05;
> +	param[1].type =3D ACPI_TYPE_INTEGER;
> +	param[1].integer.value =3D val;
> +	param[2].type =3D ACPI_TYPE_INTEGER;
> +	param[2].integer.value =3D 0;
> +	param[3].type =3D ACPI_TYPE_INTEGER;
> +	param[3].integer.value =3D 0;
> +	input.count =3D 4;
> +	input.pointer =3D param;
> +	return acpi_evaluate_object(handle, "ACMD", &input, NULL);
> +}
> +
> +static acpi_status cmpc_get_accel_v4(acpi_handle handle,
> +				     int16_t *x,
> +				     int16_t *y,
> +				     int16_t *z)
> +{
> +	union acpi_object param[4];
> +	struct acpi_object_list input;
> +	struct acpi_buffer output =3D { ACPI_ALLOCATE_BUFFER, NULL };
> +	int16_t *locs;
> +	acpi_status status;
> +
> +	param[0].type =3D ACPI_TYPE_INTEGER;
> +	param[0].integer.value =3D 0x01;
> +	param[1].type =3D ACPI_TYPE_INTEGER;
> +	param[1].integer.value =3D 0;
> +	param[2].type =3D ACPI_TYPE_INTEGER;
> +	param[2].integer.value =3D 0;
> +	param[3].type =3D ACPI_TYPE_INTEGER;
> +	param[3].integer.value =3D 0;
> +	input.count =3D 4;
> +	input.pointer =3D param;
> +	status =3D acpi_evaluate_object(handle, "ACMD", &input, &output);
> +	if (ACPI_SUCCESS(status)) {
> +		union acpi_object *obj;
> +		obj =3D output.pointer;
> +		locs =3D (int16_t *) obj->buffer.pointer;
> +		*x =3D locs[0];
> +		*y =3D locs[1];
> +		*z =3D locs[2];
> +		kfree(output.pointer);
> +	}
> +	return status;
> +}
> +
> +static void cmpc_accel_handler_v4(struct acpi_device *dev, u32 event)
> +{
> +	if (event =3D=3D 0x81) {
> +		int16_t x, y, z;
> +		acpi_status status;
> +
> +		status =3D cmpc_get_accel_v4(dev->handle, &x, &y, &z);
> +		if (ACPI_SUCCESS(status)) {
> +			struct input_dev *inputdev =3D dev_get_drvdata(&dev->dev);
> +
> +			input_report_abs(inputdev, ABS_X, x);
> +			input_report_abs(inputdev, ABS_Y, y);
> +			input_report_abs(inputdev, ABS_Z, z);
> +			input_sync(inputdev);
> +		}
> +	}
> +}
> +
> +static ssize_t cmpc_accel_sensitivity_show_v4(struct device *dev,
> +					      struct device_attribute *attr,
> +					      char *buf)
> +{
> +	struct acpi_device *acpi;
> +	struct input_dev *inputdev;
> +	struct cmpc_accel *accel;
> +
> +	acpi =3D to_acpi_device(dev);
> +	inputdev =3D dev_get_drvdata(&acpi->dev);
> +	accel =3D dev_get_drvdata(&inputdev->dev);
> +
> +	return sprintf(buf, "%d\n", accel->sensitivity);
> +}
> +
> +static ssize_t cmpc_accel_sensitivity_store_v4(struct device *dev,
> +					       struct device_attribute *attr,
> +					       const char *buf, size_t count)
> +{
> +	struct acpi_device *acpi;
> +	struct input_dev *inputdev;
> +	struct cmpc_accel *accel;
> +	unsigned long sensitivity;
> +	int r;
> +
> +	acpi =3D to_acpi_device(dev);
> +	inputdev =3D dev_get_drvdata(&acpi->dev);
> +	accel =3D dev_get_drvdata(&inputdev->dev);
> +
> +	r =3D kstrtoul(buf, 0, &sensitivity);
> +	if (r)
> +		return r;
> +
> +	/* sensitivity must be between 1 and 127 */
> +	if (sensitivity < 1 || sensitivity > 127)
> +		return -EINVAL;
> +
> +	accel->sensitivity =3D sensitivity;
> +	cmpc_accel_set_sensitivity_v4(acpi->handle, sensitivity);
> +
> +	return strnlen(buf, count);
> +}
> +
> +static struct device_attribute cmpc_accel_sensitivity_attr_v4 =3D {
> +	.attr =3D { .name =3D "sensitivity", .mode =3D 0660 },
> +	.show =3D cmpc_accel_sensitivity_show_v4,
> +	.store =3D cmpc_accel_sensitivity_store_v4
> +};
> +
> +static ssize_t cmpc_accel_g_select_show_v4(struct device *dev,
> +					   struct device_attribute *attr,
> +					   char *buf)
> +{
> +	struct acpi_device *acpi;
> +	struct input_dev *inputdev;
> +	struct cmpc_accel *accel;
> +
> +	acpi =3D to_acpi_device(dev);
> +	inputdev =3D dev_get_drvdata(&acpi->dev);
> +	accel =3D dev_get_drvdata(&inputdev->dev);
> +
> +	return sprintf(buf, "%d\n", accel->g_select);
> +}
> +
> +static ssize_t cmpc_accel_g_select_store_v4(struct device *dev,
> +					    struct device_attribute *attr,
> +					    const char *buf, size_t count)
> +{
> +	struct acpi_device *acpi;
> +	struct input_dev *inputdev;
> +	struct cmpc_accel *accel;
> +	unsigned long g_select;
> +	int r;
> +
> +	acpi =3D to_acpi_device(dev);
> +	inputdev =3D dev_get_drvdata(&acpi->dev);
> +	accel =3D dev_get_drvdata(&inputdev->dev);
> +
> +	r =3D kstrtoul(buf, 0, &g_select);
> +	if (r)
> +		return r;
> +
> +	/* 0 means 1.5g, 1 means 6g, everything else is wrong */
> +	if (g_select !=3D 0 && g_select !=3D 1)
> +		return -EINVAL;
> +
> +	accel->g_select =3D g_select;
> +	cmpc_accel_set_g_select_v4(acpi->handle, g_select);
> +
> +	return strnlen(buf, count);
> +}
> +
> +static struct device_attribute cmpc_accel_g_select_attr_v4 =3D {
> +	.attr =3D { .name =3D "g_select", .mode =3D 0660 },
> +	.show =3D cmpc_accel_g_select_show_v4,
> +	.store =3D cmpc_accel_g_select_store_v4
> +};
> +
> +static int cmpc_accel_open_v4(struct input_dev *input)
> +{
> +	struct acpi_device *acpi;
> +	struct cmpc_accel *accel;
> +
> +	acpi =3D to_acpi_device(input->dev.parent);
> +	accel =3D dev_get_drvdata(&input->dev);
> +
> +	cmpc_accel_set_sensitivity_v4(acpi->handle, accel->sensitivity);
> +	cmpc_accel_set_g_select_v4(acpi->handle, accel->g_select);
> +
> +	if (ACPI_SUCCESS(cmpc_start_accel_v4(acpi->handle))) {
> +		accel->inputdev_state =3D CMPC_ACCEL_DEV_STATE_OPEN;
> +		return 0;
> +	}
> +	return -EIO;
> +}
> +
> +static void cmpc_accel_close_v4(struct input_dev *input)
> +{
> +	struct acpi_device *acpi;
> +	struct cmpc_accel *accel;
> +
> +	acpi =3D to_acpi_device(input->dev.parent);
> +	accel =3D dev_get_drvdata(&input->dev);
> +
> +	cmpc_stop_accel_v4(acpi->handle);
> +	accel->inputdev_state =3D CMPC_ACCEL_DEV_STATE_CLOSED;
> +}
> +
> +static void cmpc_accel_idev_init_v4(struct input_dev *inputdev)
> +{
> +	set_bit(EV_ABS, inputdev->evbit);
> +	input_set_abs_params(inputdev, ABS_X, -255, 255, 16, 0);
> +	input_set_abs_params(inputdev, ABS_Y, -255, 255, 16, 0);
> +	input_set_abs_params(inputdev, ABS_Z, -255, 255, 16, 0);
> +	inputdev->open =3D cmpc_accel_open_v4;
> +	inputdev->close =3D cmpc_accel_close_v4;
> +}
> +
> +static int cmpc_accel_suspend_v4(struct acpi_device *acpi, pm_message_t =
state)
> +{
> +	struct input_dev *inputdev;
> +	struct cmpc_accel *accel;
> +
> +	inputdev =3D dev_get_drvdata(&acpi->dev);
> +	accel =3D dev_get_drvdata(&inputdev->dev);
> +
> +	if (accel->inputdev_state =3D=3D CMPC_ACCEL_DEV_STATE_OPEN)
> +		return cmpc_stop_accel_v4(acpi->handle);
> +
> +	return 0;
> +}
> +
> +static int cmpc_accel_resume_v4(struct acpi_device *acpi)
> +{
> +
> +	struct input_dev *inputdev;
> +	struct cmpc_accel *accel;
> +
> +	inputdev =3D dev_get_drvdata(&acpi->dev);
> +	accel =3D dev_get_drvdata(&inputdev->dev);
> +
> +	if (accel->inputdev_state =3D=3D CMPC_ACCEL_DEV_STATE_OPEN) {
> +		cmpc_accel_set_sensitivity_v4(acpi->handle, accel->sensitivity);
> +		cmpc_accel_set_g_select_v4(acpi->handle, accel->g_select);
> +
> +		if (ACPI_FAILURE(cmpc_start_accel_v4(acpi->handle)))
> +			return -EIO;
> +	}
> +
> +	return 0;
> +}
> +
> +static int cmpc_accel_add_v4(struct acpi_device *acpi)
> +{
> +	int error;
> +	struct input_dev *inputdev;
> +	struct cmpc_accel *accel;
> +
> +	accel =3D kmalloc(sizeof(*accel), GFP_KERNEL);
> +	if (!accel)
> +		return -ENOMEM;
> +
> +	accel->inputdev_state =3D CMPC_ACCEL_DEV_STATE_CLOSED;
> +
> +	accel->sensitivity =3D CMPC_ACCEL_SENSITIVITY_DEFAULT;
> +	cmpc_accel_set_sensitivity_v4(acpi->handle, accel->sensitivity);
> +
> +	error =3D device_create_file(&acpi->dev, &cmpc_accel_sensitivity_attr_v=
4);
> +	if (error)
> +		goto failed_sensitivity;
> +
> +	accel->g_select =3D CMPC_ACCEL_G_SELECT_DEFAULT;
> +	cmpc_accel_set_g_select_v4(acpi->handle, accel->g_select);
> +
> +	error =3D device_create_file(&acpi->dev, &cmpc_accel_g_select_attr_v4);
> +	if (error)
> +		goto failed_g_select;
> +
> +	error =3D cmpc_add_acpi_notify_device(acpi, "cmpc_accel_v4",
> +					    cmpc_accel_idev_init_v4);
> +	if (error)
> +		goto failed_input;
> +
> +	inputdev =3D dev_get_drvdata(&acpi->dev);
> +	dev_set_drvdata(&inputdev->dev, accel);
> +
> +	return 0;
> +
> +failed_input:
> +	device_remove_file(&acpi->dev, &cmpc_accel_g_select_attr_v4);
> +failed_g_select:
> +	device_remove_file(&acpi->dev, &cmpc_accel_sensitivity_attr_v4);
> +failed_sensitivity:
> +	kfree(accel);
> +	return error;
> +}
> +
> +static int cmpc_accel_remove_v4(struct acpi_device *acpi, int type)
> +{
> +	struct input_dev *inputdev;
> +	struct cmpc_accel *accel;
> +
> +	inputdev =3D dev_get_drvdata(&acpi->dev);
> +	accel =3D dev_get_drvdata(&inputdev->dev);
> +
> +	device_remove_file(&acpi->dev, &cmpc_accel_sensitivity_attr_v4);
> +	device_remove_file(&acpi->dev, &cmpc_accel_g_select_attr_v4);
> +	return cmpc_remove_acpi_notify_device(acpi);
> +}
> +
> +static const struct acpi_device_id cmpc_accel_device_ids_v4[] =3D {
> +	{CMPC_ACCEL_HID_V4, 0},
> +	{"", 0}
> +};
> +
> +static struct acpi_driver cmpc_accel_acpi_driver_v4 =3D {
> +	.owner =3D THIS_MODULE,
> +	.name =3D "cmpc_accel_v4",
> +	.class =3D "cmpc_accel_v4",
> +	.ids =3D cmpc_accel_device_ids_v4,
> +	.ops =3D {
> +		.add =3D cmpc_accel_add_v4,
> +		.remove =3D cmpc_accel_remove_v4,
> +		.notify =3D cmpc_accel_handler_v4,
> +		.suspend =3D cmpc_accel_suspend_v4,
> +		.resume =3D cmpc_accel_resume_v4,
> +	}
> +};
> +
> +
> +/*
> + * Accelerometer code for Classmate versions prior to V4
>   */
>  static acpi_status cmpc_start_accel(acpi_handle handle)
>  {
> @@ -723,8 +1110,15 @@ static int cmpc_init(void)
>  	if (r)
>  		goto failed_accel;
> =20
> +	r =3D acpi_bus_register_driver(&cmpc_accel_acpi_driver_v4);
> +	if (r)
> +		goto failed_accel_v4;
> +
>  	return r;
> =20
> +failed_accel_v4:
> +	acpi_bus_unregister_driver(&cmpc_accel_acpi_driver);
> +
>  failed_accel:
>  	acpi_bus_unregister_driver(&cmpc_tablet_acpi_driver);
> =20
> @@ -740,6 +1134,7 @@ failed_keys:
> =20
>  static void cmpc_exit(void)
>  {
> +	acpi_bus_unregister_driver(&cmpc_accel_acpi_driver_v4);
>  	acpi_bus_unregister_driver(&cmpc_accel_acpi_driver);
>  	acpi_bus_unregister_driver(&cmpc_tablet_acpi_driver);
>  	acpi_bus_unregister_driver(&cmpc_ipml_acpi_driver);
> @@ -751,6 +1146,7 @@ module_exit(cmpc_exit);
> =20
>  static const struct acpi_device_id cmpc_device_ids[] =3D {
>  	{CMPC_ACCEL_HID, 0},
> +	{CMPC_ACCEL_HID_V4, 0},
>  	{CMPC_TABLET_HID, 0},
>  	{CMPC_IPML_HID, 0},
>  	{CMPC_KEYS_HID, 0},
> --=20
> 1.7.9.5
>=20

--HcAYCG3uE/tztfnV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQBeuUAAoJEAq6ZQNy/ZVx4XQP/2Bd6ECEOGQ32EpI6T9pYRWQ
ZdfZigiwVRXpuPPGS//AgXF1ZDaEsjkjgxrHJkOmDKvZI32RDUZj/zqBPDY65ndr
ohT8Yp58nr6aSeIefxgow2tI/D7/c6Q3a3ZZnFVXK5L+yPIt313iN65ykrm/t0Lf
n494j4q3TtOHV21z2Fb0rgGeas7BbhQ1zVI8bRejUq7IiQ6qibU9dOkgdyqdDKLR
CH3kVvVZYak52Yxx33oI1FGfZY0b4Su5U6UHzIGUqUXkolxeLNsvhXZcD0MvQSp7
mdIkI7Wjj0jiouCOYKVl6whjGkeij/X9ArjmIJDKuEIedggReQorTeCuDM6zjl/1
PDtd5ZdoGAwrYviP/YIj3xbvzELaegjAvdQSJKq0j9Az+j5fUP9tr/DyVrTJkm2V
fShFFu6e7PrRslxCT5Yyt0xJ0ykK1T7DsbxIo+zvDn7PnPYROEbl9u5BHQIaMTcN
Smtb1ft3IO9uO2WrxqGD8+b2wOGxAuUiwODK8Ea0jyfe3DX71+2bqz0nh9zXSJ9w
MWZpfg4M0HxCGQCmnNPY+SLCRWP9j4ChYscYWtFXDsA89CyR3yEXCH4jGwjQMNLD
UYlE876A/NIhDKLxLGN0Mp6Z+tOZ5UaffkrixQcoRwPN+qYScZbpTo0sPcv986We
kA4/I2V/+t1jf3vwMdxJ
=cudW
-----END PGP SIGNATURE-----

--HcAYCG3uE/tztfnV--
